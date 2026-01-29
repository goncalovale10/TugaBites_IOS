import XCTest
@testable import TugaBites1_

final class LocalRecipeRepositoryTests: XCTestCase {

    func testReloadLoadsRecipesFromTestJSON() {
        // Arrange
        // Usar o bundle dos testes, onde o JSON de teste está incluído
        let testBundle = Bundle(for: LocalRecipeRepositoryTests.self)

        // Act
        let repo = LocalRecipeRepository(bundle: testBundle, resourceName: "recipes_test_one")

        // Assert
        XCTAssertEqual(repo.recipes.count, 1, "Devia carregar exatamente 1 receita do JSON de teste.")
        XCTAssertEqual(repo.recipes.first?.id, 1)
        XCTAssertEqual(repo.recipes.first?.name, "Bacalhau")
    }

    func testReloadFiltersInvalidRecipesByEmptyName() {
        // Arrange
        let testBundle = Bundle(for: LocalRecipeRepositoryTests.self)

        // Act
        let repo = LocalRecipeRepository(bundle: testBundle, resourceName: "recipes_test")

        // Assert
        // O JSON tem 2 receitas, mas a segunda tem nome vazio -> deve ser removida pelo validateRecipe
        XCTAssertEqual(repo.recipes.count, 1, "A receita inválida devia ser filtrada.")
        XCTAssertEqual(repo.recipes.first?.id, 1)
    }

    func testReloadWhenFileDoesNotExistReturnsEmpty() {
        // Arrange
        let testBundle = Bundle(for: LocalRecipeRepositoryTests.self)

        // Act
        let repo = LocalRecipeRepository(bundle: testBundle, resourceName: "this_file_does_not_exist")

        // Assert
        XCTAssertTrue(repo.recipes.isEmpty, "Quando o ficheiro não existe, devia ficar vazio e não crashar.")
    }
}
