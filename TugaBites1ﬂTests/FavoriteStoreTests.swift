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
            ingredients: ["bacalhau"],
            steps: ["cozer"]
        )
    }

    func testToggleAddsRecipeToFavorites() {
        // Arrange
        let store = FavoritesStore()
        let recipe = makeRecipe(id: 1)

        // Act
        store.toggle(recipe)

        // Assert
        XCTAssertTrue(store.isFavorite(recipe), "A receita devia ficar marcada como favorita.")
        XCTAssertTrue(store.favoriteIDs.contains(1), "O ID devia existir no Set de favoritos.")
    }

    func testToggleRemovesRecipeFromFavorites() {
        // Arrange
        let store = FavoritesStore()
        let recipe = makeRecipe(id: 1)

        // Act
        store.toggle(recipe) // adiciona
        store.toggle(recipe) // remove

        // Assert
        XCTAssertFalse(store.isFavorite(recipe), "A receita já não devia estar nos favoritos.")
        XCTAssertFalse(store.favoriteIDs.contains(1), "O ID já não devia existir no Set de favoritos.")
    }

    func testFavoritesPersistBetweenInstances() {
        // Arrange
        let recipe = makeRecipe(id: 7)

        // Act (1ª instância grava no UserDefaults.standard)
        let store1 = FavoritesStore()
        store1.toggle(recipe)

        // Act (2ª instância deve carregar do UserDefaults.standard)
        let store2 = FavoritesStore()

        // Assert
        XCTAssertTrue(store2.favoriteIDs.contains(7), "Os favoritos deviam persistir entre instâncias.")
    }
}
