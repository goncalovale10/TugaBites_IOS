import XCTest
@testable import TugaBites1_

final class FavoritesStoreTests: XCTestCase {

    private let favoritesKey = "favorite_recipe_ids"

    override func setUp() {
        super.setUp()
        // Garantir que cada teste começa limpo (UserDefaults pode vir “sujo” de execuções anteriores)
        UserDefaults.standard.removeObject(forKey: favoritesKey)
        UserDefaults.standard.synchronize()
    }

    override func tearDown() {
        // Limpar no fim também, para não afetar outros testes
        UserDefaults.standard.removeObject(forKey: favoritesKey)
        UserDefaults.standard.synchronize()
        super.tearDown()
    }

    private func makeRecipe(id: Int) -> Recipe {
        Recipe(
            id: id,
            name: "Test Recipe",
            imageName: "test",
            category: .fish,
            prepTimeMinutes: 10,
            calories: 100,
            ingredients: ["codfish"],
            steps: ["boil"]
        )
    }

    func testToggleAddsRecipeToFavorites() {
        // Arrange
        let store = FavoritesStore()
        let recipe = makeRecipe(id: 1)

        // Act
        store.toggle(recipe)

        // Assert
        XCTAssertTrue(store.isFavorite(recipe), "The recipe should be marked as favorite.")
        XCTAssertTrue(store.favoriteIDs.contains(1), "The recipe ID should exist in the favorites set.")
    }

    func testToggleRemovesRecipeFromFavorites() {
        // Arrange
        let store = FavoritesStore()
        let recipe = makeRecipe(id: 1)

        // Act
        store.toggle(recipe) // adiciona
        store.toggle(recipe) // remove

        // Assert
        XCTAssertFalse(store.isFavorite(recipe), "The recipe should no longer be marked as favorite.")
        XCTAssertFalse(store.favoriteIDs.contains(1), "The recipe ID should no longer exist in the favorites set.")
    }
}
