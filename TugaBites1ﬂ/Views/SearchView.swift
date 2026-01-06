import SwiftUI

struct SearchView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @EnvironmentObject var favorites: FavoritesStore
    @StateObject private var vm = SearchViewModel()

    // MARK: - COLORS
    private let greenDark = Color(red: 0.18, green: 0.30, blue: 0.25)
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {

                // MARK: - SEARCH FIELDS
                VStack(spacing: 14) {
                    searchField(
                        placeholder: "Search by recipe name",
                        text: $vm.searchName,
                        icon: "magnifyingglass"
                    )

                    searchField(
                        placeholder: "Search by ingredient",
                        text: $vm.searchIngredient,
                        icon: "cart"
                    )
                }
                .padding(.horizontal)

                // MARK: - CATEGORY FILTER
                categorySection

                // MARK: - RESULTS
                if vm.filteredRecipes.isEmpty {

                    if vm.searchName.isEmpty &&
                        vm.searchIngredient.isEmpty &&
                        vm.selectedCategory == nil {

                        Text("Search recipes by name, ingredient or category")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)

                    } else {
                        Text("No recipes found")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    }
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(vm.filteredRecipes) { recipe in
                            NavigationLink(value: recipe) {
                                RecipeRow(recipe: recipe)
                                    .environmentObject(favorites)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .background(backgroundBeige.ignoresSafeArea())
        .navigationTitle("Search")
        .onAppear {
            vm.setRecipes(repo.recipes)
        }
    }

    // MARK: - SEARCH FIELD
    private func searchField(
        placeholder: String,
        text: Binding<String>,
        icon: String
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(greenDark)

            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onChange(of: text.wrappedValue) {
                    vm.applyFilters()
                }


            if !text.wrappedValue.isEmpty {
                Button {
                    text.wrappedValue = ""
                    vm.applyFilters()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 4)
    }

    // MARK: - CATEGORY SECTION
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(greenDark)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    // ALL
                    filterChip(
                        label: "All",
                        isSelected: vm.selectedCategory == nil
                    ) {
                        vm.selectedCategory = nil
                        vm.applyFilters()
                    }

                    ForEach(Category.allCases) { category in
                        filterChip(
                            label: category.rawValue,
                            isSelected: vm.selectedCategory == category
                        ) {
                            vm.selectedCategory =
                                vm.selectedCategory == category ? nil : category
                            vm.applyFilters()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - FILTER CHIP (INLINE)
    @ViewBuilder
    private func filterChip(
        label: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : greenDark)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? greenDark : Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(greenDark, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
