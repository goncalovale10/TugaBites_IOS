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
        // Scroll vertical do ecrã de pesquisa
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {

                // MARK: - Search Field (único)
                VStack(spacing: 14) {
                    // Campo de pesquisa ligado ao vm.searchQuery
                    searchField(
                        placeholder: "Search recipes or ingredients",
                        text: $vm.searchQuery,
                        icon: "magnifyingglass"
                    )
                }
                .padding(.horizontal)

                // MARK: - Category Filter
                // Secção horizontal com chips de categoria
                categorySection

                // MARK: - Results
                Group {
                    // Se não há resultados filtrados
                    if vm.filteredRecipes.isEmpty {

                        // Caso “estado inicial” (sem query e sem categoria)
                        if vm.searchQuery.isEmpty &&
                            vm.selectedCategory == nil {

                            Text("Search recipes by name, ingredient or category")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                                .transition(.opacity)

                        } else {

                            // Caso “sem resultados” (há filtro ativo)
                            Text("No recipes found")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                                .transition(.opacity)
                        }

                    } else {

                        // Lista de resultados (Lazy para performance)
                        LazyVStack(spacing: 16) {
                            ForEach(vm.filteredRecipes) { recipe in
                                // Tocar num resultado navega para o detalhe
                                NavigationLink(value: recipe) {
                                    // Linha reutilizável da receita
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
                // Anima transições quando resultados/categoria mudam
                .animation(.easeInOut(duration: 0.20), value: vm.filteredRecipes.count)
                .animation(.easeInOut(duration: 0.20), value: vm.selectedCategory)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .background(backgroundBeige.ignoresSafeArea())
        .navigationTitle("Search")

        // Ao abrir o ecrã, injeta as receitas no ViewModel
        .onAppear {
            vm.setRecipes(repo.recipes)
        }
    }

    // MARK: - Search Field Component
    // Componente reutilizável do campo de pesquisa
    private func searchField(
        placeholder: String,
        text: Binding<String>,
        icon: String
    ) -> some View {
        HStack {
            // Ícone de pesquisa
            Image(systemName: icon)
                .foregroundColor(greenDark)

            // TextField ligado ao binding recebido (vm.searchQuery)
            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                // Sempre que o texto muda, reaplica filtros
                .onChange(of: text.wrappedValue) {
                    vm.applyFilters()
                    // Pequeno bounce no ícone de limpar
                    withAnimation(.easeInOut(duration: 0.15)) {
                        showClearBounce.toggle()
                    }
                }

            // Botão para limpar texto (só aparece quando há texto)
            if !text.wrappedValue.isEmpty {
                Button {
                    // Limpa o texto com animação
                    withAnimation(.easeInOut(duration: 0.18)) {
                        text.wrappedValue = ""
                    }
                    // Reaplica filtros após limpar
                    vm.applyFilters()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .symbolEffect(.bounce, value: showClearBounce)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        // Estilo do campo
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 4)
        .animation(.easeInOut(duration: 0.18), value: text.wrappedValue.isEmpty)
    }

    // MARK: - Category Section
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Título “Category”
            Text("Category")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(greenDark)
                .padding(.horizontal)

            // Chips horizontais
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    // Chip “All” (remove filtro)
                    filterChip(
                        label: "All",
                        isSelected: vm.selectedCategory == nil
                    ) {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            vm.selectedCategory = nil
                        }
                        vm.applyFilters()
                    }

                    // Chips para cada categoria existente
                    ForEach(Category.allCases) { category in
                        filterChip(
                            label: category.rawValue,
                            isSelected: vm.selectedCategory == category
                        ) {
                            // Toggle: se clicar na mesma, desmarca (volta a nil)
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
                // Cores mudam conforme seleção
                .foregroundColor(isSelected ? .white : greenDark)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? greenDark : Color.white)
                .clipShape(Capsule())
                // Borda sempre presente
                .overlay(
                    Capsule()
                        .stroke(greenDark, lineWidth: 1)
                )
                // Leve zoom quando selecionado
                .scaleEffect(isSelected ? 1.03 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}
