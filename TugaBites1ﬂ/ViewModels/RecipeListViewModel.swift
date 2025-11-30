import Foundation
import Combine

final class RecipeListViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var selectedCategory: Category? = nil
    @Published private(set) var filtered: [Recipe] = []

    private var repo: LocalRecipeRepository
    private var cancellables = Set<AnyCancellable>()

    init(repo: LocalRecipeRepository) {
        self.repo = repo
        bind()
    }

    private func bind() {
        cancellables.removeAll() // limpa pipelines antigos

        repo.$recipes
            .combineLatest($searchText, $selectedCategory)
            .map { recipes, query, category in
                var list = recipes

                // Filtrar categoria
                if let cat = category {
                    list = list.filter { $0.category == cat }
                }

                // Filtrar texto
                if !query.isEmpty {
                    let q = query.lowercased()
                    list = list.filter { r in
                        r.name.lowercased().contains(q) ||
                        r.ingredients.contains { $0.lowercased().contains(q) }
                    }
                }

                return list
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$filtered)
    }

    /// Atualiza o repo quando a View recebe o repo do ambiente
    func setRepository(_ newRepo: LocalRecipeRepository) {
        self.repo = newRepo
        bind() // reconstrói o pipeline combinando com o novo repo
    }
}
