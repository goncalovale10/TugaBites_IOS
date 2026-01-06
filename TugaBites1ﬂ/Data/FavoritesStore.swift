import Foundation
import Combine

/// Store responsável por gerir os favoritos do utilizador.
/// Guarda apenas os IDs das receitas favoritas e persiste localmente.
final class FavoritesStore: ObservableObject {

    // Conjunto de IDs das receitas favoritas
    @Published private(set) var favoriteIDs: Set<Int> = []

    // Chave usada no UserDefaults
    private let key = "favorite_recipe_ids"

    init() {
        load()
    }

    /// Adiciona ou remove uma receita dos favoritos
    func toggle(_ recipe: Recipe) {
        if favoriteIDs.contains(recipe.id) {
            favoriteIDs.remove(recipe.id)
        } else {
            favoriteIDs.insert(recipe.id)
        }
        save()
    }

    /// Verifica se uma receita está marcada como favorita
    func isFavorite(_ recipe: Recipe) -> Bool {
        favoriteIDs.contains(recipe.id)
    }

    // MARK: - Persistence

    /// Guarda os favoritos no UserDefaults
    private func save() {
        let array = Array(favoriteIDs)
        UserDefaults.standard.set(array, forKey: key)
    }

    /// Carrega os favoritos do UserDefaults
    private func load() {
        let array = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        favoriteIDs = Set(array)
    }
}
