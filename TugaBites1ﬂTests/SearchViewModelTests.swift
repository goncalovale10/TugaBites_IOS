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
        let vm = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Bacalhau à Brás", category: .fish, ingredients: ["bacalhau", "ovo"]),
            makeRecipe(id: 2, name: "Leitão", category: .meat, ingredients: ["carne de porco"])
        ]

        // Act
        vm.setRecipes(recipes)
        vm.selectedCategory = .fish
        vm.searchQuery = ""
        vm.applyFilters()

        // Assert
        XCTAssertEqual(vm.filteredRecipes.map(\.id), [1], "Devia filtrar apenas por categoria.")
    }

    func testSearchByNameIsCaseInsensitive() {
        // Arrange
        let vm = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Bacalhau à Brás", category: .fish, ingredients: ["x"]),
            makeRecipe(id: 2, name: "Arroz Doce", category: .dessert, ingredients: ["y"])
        ]

        // Act
        vm.setRecipes(recipes)
        vm.selectedCategory = nil
        vm.searchQuery = "BACALHAU"
        vm.applyFilters()

        // Assert
        XCTAssertEqual(vm.filteredRecipes.map(\.id), [1], "Devia encontrar por nome sem depender de maiúsculas/minúsculas.")
    }

    func testSearchByIngredientMatchesSubstring() {
        // Arrange
        let vm = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Caldo Verde", category: .soup, ingredients: ["kale", "chouriço"]),
            makeRecipe(id: 2, name: "Salada", category: .other, ingredients: ["tomate", "azeite"])
        ]

        // Act
        vm.setRecipes(recipes)
        vm.selectedCategory = nil
        vm.searchQuery = "chouri"
        vm.applyFilters()

        // Assert
        XCTAssertEqual(vm.filteredRecipes.map(\.id), [1], "Devia encontrar por ingrediente usando substring.")
    }

    func testCombinedCategoryAndSearchQuery() {
        // Arrange
        let vm = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "Bacalhau com Natas", category: .fish, ingredients: ["batata", "bacalhau"]),
            makeRecipe(id: 2, name: "Bacalhau à Brás", category: .fish, ingredients: ["bacalhau", "ovo"]),
            makeRecipe(id: 3, name: "Francesinha", category: .meat, ingredients: ["carne", "pão"])
        ]

        // Act
        vm.setRecipes(recipes)
        vm.selectedCategory = .fish
        vm.searchQuery = "brás"
        vm.applyFilters()

        // Assert
        XCTAssertEqual(vm.filteredRecipes.map(\.id), [2], "Devia combinar filtro de categoria + texto.")
    }

    func testWhitespaceQueryIsTreatedAsEmpty() {
        // Arrange
        let vm = SearchViewModel()
        let recipes = [
            makeRecipe(id: 1, name: "A", category: .other, ingredients: ["x"]),
            makeRecipe(id: 2, name: "B", category: .other, ingredients: ["y"])
        ]

        // Act
        vm.setRecipes(recipes)
        vm.selectedCategory = nil
        vm.searchQuery = "   \n "
        vm.applyFilters()

        // Assert
        XCTAssertEqual(vm.filteredRecipes.count, 2, "Texto vazio/whitespace devia devolver todas as receitas.")
    }
}
