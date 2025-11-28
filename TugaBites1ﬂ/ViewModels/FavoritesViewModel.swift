
import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published private(set) var items: [Recipe] = []

    private var cancellables = Set<AnyCancellable>()

    init(repo: LocalRecipeRepository, favs: FavoritesStore) {
        Publishers.CombineLatest(repo.$recipes, favs.$favoriteIDs)
            .map { recipes, ids in
                recipes.filter { ids.contains($0.id) }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$items)
    }
}

