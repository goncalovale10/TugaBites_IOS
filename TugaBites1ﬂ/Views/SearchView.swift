import SwiftUI

struct SearchView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @EnvironmentObject var favorites: FavoritesStore
    @StateObject private var vm: RecipeListViewModel

    init() {
        // Criamos um VM placeholder
        _vm = StateObject(wrappedValue: RecipeListViewModel(repo: LocalRecipeRepository()))
    }

    var body: some View {
        VStack {
            TextField("Search recipes or ingredients", text: $vm.searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            List(vm.filtered) { recipe in
                NavigationLink(value: recipe) {
                    RecipeRow(recipe: recipe)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Search")
        .onAppear {
            vm.setRepository(repo)
        }
    }
}
