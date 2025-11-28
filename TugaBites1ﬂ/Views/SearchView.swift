
import SwiftUI

struct SearchView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @StateObject private var vm: RecipeListViewModel

    init() {
        _vm = StateObject(wrappedValue: RecipeListViewModel(repo: LocalRecipeRepository()))
    }

    var body: some View {
        VStack {
            TextField("Search recipes or ingredients", text: $vm.searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            List(vm.filtered) { recipe in
                NavigationLink(value: recipe) {
                    RecipeRow(recipe: recipe)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Search")
    }
}
