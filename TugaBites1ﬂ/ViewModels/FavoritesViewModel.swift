import Foundation
import Combine

/// ViewModel responsável por fornecer as receitas favoritas à View
final class FavoritesViewModel: ObservableObject {

    /// Lista de receitas favoritas
    @Published private(set) var items: [Recipe] = []

    private var cancellables = Set<AnyCancellable>()

    /// Inicializa com o repositório de receitas e o store de favoritos
    init(repo: LocalRecipeRepository, favs: FavoritesStore) {

        Publishers.CombineLatest(repo.$recipes, favs.$favoriteIDs)
            // Filtra apenas as receitas cujo ID está nos favoritos
            .map { recipes, ids in
                recipes.filter { ids.contains($0.id) }
            }
            // Garante atualização da UI na main thread
            .receive(on: DispatchQueue.main)
            // Atribui automaticamente o resultado à lista de itens
            .assign(to: &$items)
    }
}

