import Foundation
import Combine

final class SearchViewModel: ObservableObject {

    @Published var searchQuery: String = ""
    @Published var selectedCategory: Category? = nil
    @Published private(set) var filteredRecipes: [Recipe] = []

    private var allRecipes: [Recipe] = []

    func setRecipes(_ recipes: [Recipe]) {
        allRecipes = recipes
        applyFilters()
    }

    func applyFilters() {
        let q = searchQuery
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        filteredRecipes = allRecipes.filter { recipe in

            // 1) Categoria (se estiver selecionada)
            let matchesCategory =
                selectedCategory == nil || recipe.category == selectedCategory

            // 2) Texto (nome OU ingredientes)
            let matchesQuery: Bool = {
                guard !q.isEmpty else { return true }

                let matchesName = recipe.name.lowercased().contains(q)

                let matchesIngredient = recipe.ingredients.contains { ing in
                    ing.lowercased().contains(q)
                }

                return matchesName || matchesIngredient
            }()

            return matchesCategory && matchesQuery
        }
    }
}
