
import Foundation
import Combine

final class RecipeListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: Category? = nil
    @Published private(set) var filtered: [Recipe] = []

    private var cancellables = Set<AnyCancellable>()

    init(repo: LocalRecipeRepository) {   // ← CORREÇÃO AQUI
        repo.$recipes
            .combineLatest($searchText, $selectedCategory)
            .map { recipes, query, category in
                var list = recipes

                if let cat = category {
                    list = list.filter { $0.category == cat }
                }

                if !query.isEmpty {
                    let q = query.lowercased()
                    list = list.filter { r in
                        r.name.lowercased().contains(q) ||
                        r.ingredients.contains(where: { $0.lowercased().contains(q) })
                    }
                }

                return list
            }
            .assign(to: &$filtered)
    }
}
