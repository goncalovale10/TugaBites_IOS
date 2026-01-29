import Foundation
import Combine

final class FavoritesStore: ObservableObject {

    @Published private(set) var favoriteIDs: Set<Int> = []

    private let key: String
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard, key: String = "favorite_recipe_ids") {
        self.defaults = defaults
        self.key = key
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

    func isFavorite(_ recipe: Recipe) -> Bool {
        favoriteIDs.contains(recipe.id)
    }

    private func save() {
        defaults.set(Array(favoriteIDs), forKey: key)
    }

    private func load() {
        let array = defaults.array(forKey: key) as? [Int] ?? []
        favoriteIDs = Set(array)
    }
}
