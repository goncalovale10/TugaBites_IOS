import XCTest
@testable import TugaBites1_

final class SearchViewModelTests: XCTestCase {

    private func makeRecipe(
        id: Int,
        name: String,
        category: TugaBites1_.Category,
        ingredients: [String]
    ) -> Recipe {
        Recipe(
            id: id,
            name: name,
            imageName: "test",
            category: category,
            prepTimeMinutes: 10,
            calories: 100,
            ingredients: ingredients,
            steps: ["step"]
        )
    }

    func testFilterByCategoryOnly() {
        // Arrange
        let viewModel = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Bacalhau à Brás", category: .fish, ingredients: ["bacalhau", "ovo"]),
            makeRecipe(id: 2, name: "Leitão", category: .meat, ingredients: ["pork"])
        ]

        // Act
        viewModel.setRecipes(recipes)
        viewModel.selectedCategory = .fish
        viewModel.searchQuery = ""
        viewModel.applyFilters()

        // Assert
        XCTAssertEqual(
            viewModel.filteredRecipes.map(\.id),
            [1],
            "It should filter recipes only by category."
        )
    }

    func testSearchByNameIsCaseInsensitive() {
        // Arrange
        let viewModel = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Bacalhau à Brás", category: .fish, ingredients: ["x"]),
            makeRecipe(id: 2, name: "Arroz Doce", category: .dessert, ingredients: ["y"])
        ]

        // Act
        viewModel.setRecipes(recipes)
        viewModel.selectedCategory = nil
        viewModel.searchQuery = "BACALHAU"
        viewModel.applyFilters()

        // Assert
        XCTAssertEqual(
            viewModel.filteredRecipes.map(\.id),
            [1],
            "It should match recipe names regardless of letter case."
        )
    }

    func testSearchByIngredientMatchesSubstring() {
        // Arrange
        let viewModel = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Caldo Verde", category: .soup, ingredients: ["kale", "chouriço"]),
            makeRecipe(id: 2, name: "Salada", category: .other, ingredients: ["tomato", "olive oil"])
        ]

        // Act
        viewModel.setRecipes(recipes)
        viewModel.selectedCategory = nil
        viewModel.searchQuery = "oil"
        viewModel.applyFilters()

        // Assert
        XCTAssertEqual(
            viewModel.filteredRecipes.map(\.id),
            [2],
            "It should find recipes by ingredient using substring matching."
        )
    }

    func testCombinedCategoryAndSearchQuery() {
        // Arrange
        let viewModel = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Bacalhau com Natas", category: .fish, ingredients: ["potato", "bacalhau"]),
            makeRecipe(id: 2, name: "Bacalhau à Brás", category: .fish, ingredients: ["bacalhau", "egg"]),
            makeRecipe(id: 3, name: "Francesinha", category: .meat, ingredients: ["meat", "bread"])
        ]

        // Act
        viewModel.setRecipes(recipes)
        viewModel.selectedCategory = .fish
        viewModel.searchQuery = "brás"
        viewModel.applyFilters()

        // Assert
        XCTAssertEqual(
            viewModel.filteredRecipes.map(\.id),
            [2],
            "It should combine category and text filters."
        )
    }

    func testWhitespaceQueryIsTreatedAsEmpty() {
        // Arrange
        let viewModel = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "A", category: .other, ingredients: ["x"]),
            makeRecipe(id: 2, name: "B", category: .other, ingredients: ["y"])
        ]

        // Act
        viewModel.setRecipes(recipes)
        viewModel.selectedCategory = nil
        viewModel.searchQuery = "   \n "
        viewModel.applyFilters()

        // Assert
        XCTAssertEqual(
            viewModel.filteredRecipes.count,
            2,
            "An empty or whitespace-only query should return all recipes."
        )
    }
}
