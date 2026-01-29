import XCTest
@testable import TugaBites1_

final class LocalRecipeRepositoryTests: XCTestCase {

    func testReloadLoadsRecipesFromTestJSON() {
        // Arrange
        // Usar o bundle dos testes, onde o JSON de teste está incluído
        let testBundle = Bundle(for: LocalRecipeRepositoryTests.self)

        // Act
        let repository = LocalRecipeRepository(
            bundle: testBundle,
            resourceName: "recipes_test_one"
        )

        // Assert
        XCTAssertEqual(repository.recipes.count, 1, "It should load exactly one recipe from the test JSON.")
        XCTAssertEqual(repository.recipes.first?.id, 1)
        XCTAssertEqual(repository.recipes.first?.name, "Bacalhau")
    }

    func testReloadFiltersInvalidRecipesByEmptyName() {
        // Arrange
        let testBundle = Bundle(for: LocalRecipeRepositoryTests.self)

        // Act
        let repository = LocalRecipeRepository(
            bundle: testBundle,
            resourceName: "recipes_test"
        )

        // Assert
        // O JSON tem 2 receitas, mas a segunda tem nome vazio -> deve ser removida pelo validateRecipe
        XCTAssertEqual(repository.recipes.count, 1, "The invalid recipe should be filtered out.")
        XCTAssertEqual(repository.recipes.first?.id, 1)
    }
}

