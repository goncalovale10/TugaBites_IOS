import Foundation
import Combine
import SwiftUI

/// Protocolo base para qualquer fonte de receitas
protocol RecipeRepository: ObservableObject {
    var recipes: [Recipe] { get }
    func reload()
}

/// Implementação local que carrega receitas a partir de um ficheiro JSON
final class LocalRecipeRepository: RecipeRepository {

    // Lista pública apenas para leitura
    @Published private(set) var recipes: [Recipe] = []

    init() {
        reload()
    }

    /// Recarrega as receitas a partir do ficheiro JSON
    func reload() {

        // Localizar o ficheiro no bundle
        guard let url = Bundle.main.url(
            forResource: "recipes",
            withExtension: "json"
        ) else {
            print("❌ ERROR: recipes.json not found in bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()

            // Decodificação inicial
            let decoded = try decoder.decode([Recipe].self, from: data)
            print("✅ Loaded \(decoded.count) recipes from JSON.")

            // Validação individual das receitas
            let validated = decoded.compactMap { validateRecipe($0) }
            print("📌 Valid recipes: \(validated.count) / \(decoded.count)")

            self.recipes = validated

        } catch {
            print("❌ JSON DECODING ERROR:")
            print(error)
            self.recipes = []
        }
    }

    // MARK: - Recipe Validation

    /// Valida campos essenciais de cada receita
    private func validateRecipe(_ recipe: Recipe) -> Recipe? {

        var isValid = true

        // Nome não pode estar vazio
        if recipe.name.trimmingCharacters(in: .whitespaces).isEmpty {
            print("❌ ERROR: Recipe ID \(recipe.id) has an empty name.")
            isValid = false
        }

        // Verifica se a imagem existe nos assets
        if UIImage(named: recipe.imageName) == nil {
            print(
                "⚠️ WARNING: Image \"\(recipe.imageName)\" NOT FOUND for recipe \(recipe.name)"
            )
        }

        // Categoria válida
        if Category(rawValue: recipe.category.rawValue) == nil {
            print(
                "❌ ERROR: Invalid category \"\(recipe.category)\" in recipe \(recipe.name)"
            )
            isValid = false
        }

        // Ingredientes
        if recipe.ingredients.isEmpty {
            print("⚠️ WARNING: Recipe \(recipe.name) has NO INGREDIENTS.")
        }

        // Passos
        if recipe.steps.isEmpty {
            print("⚠️ WARNING: Recipe \(recipe.name) has NO STEPS.")
        }

        // Tempo
        if recipe.prepTimeMinutes <= 0 {
            print(
                "⚠️ WARNING: Recipe \(recipe.name) has invalid prep time: \(recipe.prepTimeMinutes) min."
            )
        }

        // Calorias
        if recipe.calories <= 0 {
            print(
                "⚠️ WARNING: Recipe \(recipe.name) has invalid calorie count: \(recipe.calories)."
            )
        }

        return isValid ? recipe : nil
    }
}
