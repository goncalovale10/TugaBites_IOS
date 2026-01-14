import SwiftUI

struct SearchView: View {

    // Repositório principal com todas as receitas
    @EnvironmentObject var repo: LocalRecipeRepository

    // Store de favoritos (usada nos resultados)
    @EnvironmentObject var favorites: FavoritesStore

    // ViewModel responsável pela lógica de pesquisa e filtros
    @StateObject private var vm = SearchViewModel()

    // MARK: - Animações
    @State private var showClearBounce = false

    // MARK: - Colors
    private let greenDark = Color(red: 0.18, green: 0.30, blue: 0.25)
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {

                // MARK: - Search Field (único)
                VStack(spacing: 14) {
                    searchField(
                        placeholder: "Search recipes or ingredients",
                        text: $vm.searchQuery,
                        icon: "magnifyingglass"
                    )
                }
                .padding(.horizontal)

                // MARK: - Category Filter
                categorySection

                // MARK: - Results
                Group {
                    if vm.filteredRecipes.isEmpty {

                        if vm.searchQuery.isEmpty &&
                            vm.selectedCategory == nil {

                            Text("Search recipes by name, ingredient or category")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                                .transition(.opacity)

                        } else {

                            Text("No recipes found")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                                .transition(.opacity)
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
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.easeInOut(duration: 0.20), value: vm.filteredRecipes.count)
                .animation(.easeInOut(duration: 0.20), value: vm.selectedCategory)
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

    // MARK: - Search Field Component
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
                    withAnimation(.easeInOut(duration: 0.15)) {
                        showClearBounce.toggle()
                    }
                }

            if !text.wrappedValue.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        text.wrappedValue = ""
                    }
                    vm.applyFilters()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .symbolEffect(.bounce, value: showClearBounce)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 4)
        .animation(.easeInOut(duration: 0.18), value: text.wrappedValue.isEmpty)
    }

    // MARK: - Category Section
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(greenDark)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    filterChip(
                        label: "All",
                        isSelected: vm.selectedCategory == nil
                    ) {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            vm.selectedCategory = nil
                        }
                        vm.applyFilters()
                    }

                    ForEach(Category.allCases) { category in
                        filterChip(
                            label: category.rawValue,
                            isSelected: vm.selectedCategory == category
                        ) {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                vm.selectedCategory =
                                    vm.selectedCategory == category ? nil : category
                            }
                            vm.applyFilters()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Filter Chip
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
                .scaleEffect(isSelected ? 1.03 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}
