import SwiftUI

struct SearchView: View {

    // Repositório principal com todas as receitas
    @EnvironmentObject var repo: LocalRecipeRepository

    // Store de favoritos (usada nos resultados)
    @EnvironmentObject var favorites: FavoritesStore

    // ViewModel responsável apenas pela lógica de pesquisa e filtros
    @StateObject private var vm = SearchViewModel()

    // MARK: - Colors
    private let greenDark = Color(red: 0.18, green: 0.30, blue: 0.25)
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {

                // MARK: - Search Fields
                // Pesquisa por nome e por ingrediente (independentes)
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

                // MARK: - Category Filter
                categorySection

                // MARK: - Results
                // Estados diferentes consoante exista ou não pesquisa ativa
                if vm.filteredRecipes.isEmpty {

                    if vm.searchName.isEmpty &&
                        vm.searchIngredient.isEmpty &&
                        vm.selectedCategory == nil {

                        // Estado inicial (sem filtros aplicados)
                        Text("Search recipes by name, ingredient or category")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)

                    } else {

                        // Pesquisa ativa mas sem resultados
                        Text("No recipes found")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    }

                } else {

                    // Lista de resultados filtrados
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

        // Injeta as receitas no ViewModel quando o ecrã aparece
        .onAppear {
            vm.setRecipes(repo.recipes)
        }
    }

    // MARK: - Search Field Component
    // Campo reutilizável para manter consistência visual
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

            // Botão de limpar texto
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

    // MARK: - Category Section
    // Filtro horizontal por categoria
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(greenDark)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    // Opção "All" remove o filtro de categoria
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

    // MARK: - Filter Chip
    // Implementado inline para evitar criar uma View extra
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

