import Foundation
import Combine

final class SearchViewModel: ObservableObject {

    // INPUT
    @Published var searchName: String = ""
    @Published var searchIngredient: String = ""
    @Published var selectedCategory: Category?

    // OUTPUT
    @Published private(set) var filteredRecipes: [Recipe] = []

    private var allRecipes: [Recipe] = []

    func setRecipes(_ recipes: [Recipe]) {
        self.allRecipes = recipes
        applyFilters()
    }

    func applyFilters() {
        filteredRecipes = allRecipes.filter { recipe in

            let matchesName =
                searchName.isEmpty ||
                recipe.name.lowercased().contains(searchName.lowercased())

            let matchesIngredient =
                searchIngredient.isEmpty ||
                recipe.ingredients.contains {
                    $0.lowercased().contains(searchIngredient.lowercased())
                }

            let matchesCategory =
                selectedCategory == nil ||
                recipe.category == selectedCategory

            return matchesName &&
                   matchesIngredient &&
                   matchesCategory
        }
    }
}

