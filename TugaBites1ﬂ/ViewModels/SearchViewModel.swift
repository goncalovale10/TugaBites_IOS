import Foundation
import Combine

final class SearchViewModel: ObservableObject {

    // Texto que o utilizador escreve na pesquisa
    @Published var searchQuery: String = ""

    // Categoria selecionada (nil = sem filtro de categoria)
    @Published var selectedCategory: Category? = nil

    // Resultado final já filtrado para a View mostrar (apenas leitura externa)
    @Published private(set) var filteredRecipes: [Recipe] = []

    // Lista completa de receitas (fonte de dados interna)
    private var allRecipes: [Recipe] = []

    // Define/atualiza a lista base de receitas e aplica logo os filtros
    func setRecipes(_ recipes: [Recipe]) {
        allRecipes = recipes
        applyFilters()
    }

    // Aplica filtros de categoria + texto (nome ou ingredientes)
    func applyFilters() {
        // Normaliza o texto da pesquisa (remove espaços e põe em minúsculas)
        let q = searchQuery
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        // Filtra a lista completa e guarda o resultado em filteredRecipes
        filteredRecipes = allRecipes.filter { recipe in

            // 1) Categoria: se selectedCategory for nil, passa sempre
            let matchesCategory =
                selectedCategory == nil || recipe.category == selectedCategory

            // 2) Texto: se q estiver vazio, passa sempre; senão verifica nome ou ingredientes
            let matchesQuery: Bool = {
                guard !q.isEmpty else { return true }

                let matchesName = recipe.name.lowercased().contains(q)

                let matchesIngredient = recipe.ingredients.contains { ing in
                    ing.lowercased().contains(q)
                }

                return matchesName || matchesIngredient
            }()

            // Só entra no resultado se cumprir os dois critérios
            return matchesCategory && matchesQuery
        }
    }
}
