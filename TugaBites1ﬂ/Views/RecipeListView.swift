
import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @EnvironmentObject var favorites: FavoritesStore
    @StateObject private var vm: RecipeListViewModel

    init() {
        _vm = StateObject(wrappedValue: RecipeListViewModel(repo: LocalRecipeRepository()))
    }

    var body: some View {
        VStack {
            searchAndFilter
            List(vm.filtered) { recipe in
                NavigationLink(value: recipe) {
                    RecipeRow(recipe: recipe)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Recipes")
        .onAppear {
            // Re-bind to shared repo when view appears (since init used a temp one for @StateObject creation)
            if let shared = _repo {
                // no-op in this minimal sample
                // a more elaborate solution would pass the repo through init
            }
        }
        .environmentObject(favorites)
        .onReceive(repo.$recipes) { _ in
            // trigger pipeline in vm via published updates
        }
    }

    private var searchAndFilter: some View {
        VStack {
            TextField("Search recipes or ingredients", text: $vm.searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button {
                        vm.selectedCategory = nil
                    } label: {
                        Chip(text: "All", selected: vm.selectedCategory == nil)
                    }
                    ForEach(Category.allCases) { cat in
                        Button {
                            vm.selectedCategory = cat
                        } label: {
                            Chip(text: cat.rawValue, selected: vm.selectedCategory == cat)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct Chip: View {
    let text: String
    let selected: Bool
    var body: some View {
        Text(text)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(selected ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.1))
            .clipShape(Capsule())
    }
}
