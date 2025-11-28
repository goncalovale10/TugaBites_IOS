import Foundation
import Combine

final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteIDs: Set<Int> = []

    private let key = "favorite_recipe_ids"

    init() {
        load()
    }

    func toggle(_ recipe: Recipe) {
        if favoriteIDs.contains(recipe.id) {
            favoriteIDs.remove(recipe.id)
        } else {
            favoriteIDs.insert(recipe.id)
        }
        save()
    }

    private func save() {
        let array = Array(favoriteIDs)
        UserDefaults.standard.set(array, forKey: key)
    }

    private func load() {
        let array = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        favoriteIDs = Set(array)
    }
}
