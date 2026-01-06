import SwiftUI

struct RecipeListView: View {

    // Repositório principal com todas as receitas
    @EnvironmentObject var repo: LocalRecipeRepository

    // ViewModel responsável pela lógica de pesquisa e filtragem
    @StateObject private var vm: RecipeListViewModel

    // Cor de fundo consistente com o resto da app
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    // Inicialização com repo temporário (injetado corretamente no onAppear)
    init() {
        _vm = StateObject(
            wrappedValue: RecipeListViewModel(
                repo: LocalRecipeRepository()
            )
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {

                // Pesquisa por texto + filtros por categoria
                searchAndFilter

                // Lista de receitas filtradas
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

        // Injeta o repositório real no ViewModel
        .onAppear {
            vm.setRepository(repo)
        }
    }

    // MARK: - Search + Filter
    private var searchAndFilter: some View {
        VStack(spacing: 14) {

            // Campo de pesquisa por nome ou ingrediente
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField(
                    "Search recipes or ingredients",
                    text: $vm.searchText
                )
            }
            .padding(12)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 6,
                x: 0,
                y: 3
            )
            .padding(.horizontal)

            // Filtro horizontal por categorias
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    // Opção "All" remove o filtro
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

// MARK: - Chip Component
// Componente simples para filtros de categoria
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
