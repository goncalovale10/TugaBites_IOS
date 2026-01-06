import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @StateObject private var vm: RecipeListViewModel
    
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    init() {
        _vm = StateObject(wrappedValue: RecipeListViewModel(repo: LocalRecipeRepository()))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {

                // SEARCH + FILTER
                searchAndFilter

                // RECIPES
                LazyVStack(spacing: 18) {
                    ForEach(vm.filtered) { recipe in
                        NavigationLink(value: recipe) {
                            HomeRecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 12)
        }
        .background(backgroundBeige.ignoresSafeArea())
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.setRepository(repo)
        }
    }

    // MARK: - SEARCH + FILTER

    private var searchAndFilter: some View {
        VStack(spacing: 14) {

            // SEARCH
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search recipes or ingredients", text: $vm.searchText)
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
            .padding(.horizontal)

            // CHIPS
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    Chip(
                        text: "All",
                        selected: vm.selectedCategory == nil
                    ) {
                        vm.selectedCategory = nil
                    }

                    ForEach(Category.allCases) { cat in
                        Chip(
                            text: cat.rawValue,
                            selected: vm.selectedCategory == cat
                        ) {
                            vm.selectedCategory = cat
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - CHIP

private struct Chip: View {
    let text: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(selected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    selected
                    ? Color("GreenDark")
                    : Color.secondary.opacity(0.15)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
