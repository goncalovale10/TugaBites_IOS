import SwiftUI

struct SearchView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @EnvironmentObject var favorites: FavoritesStore
    @StateObject private var vm: RecipeListViewModel

    init() {
        // Inicializamos com um repo vazio TEMPORÁRIO
        _vm = StateObject(wrappedValue: RecipeListViewModel(repo: LocalRecipeRepository()))
    }

    var body: some View {
        VStack(spacing: 16) {

            // 🔍 SEARCH BAR ESTILO MODERNO
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search recipes or ingredients", text: $vm.searchText)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)

                if !vm.searchText.isEmpty {
                    Button {
                        vm.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            // RESULTADOS DA PESQUISA
            if vm.filtered.isEmpty && !vm.searchText.isEmpty {
                Text("No results found")
                    .foregroundColor(.gray)
                    .padding(.top, 40)
            } else {
                List(vm.filtered) { recipe in
                    NavigationLink(value: recipe) {
                        RecipeRow(recipe: recipe)
                            .environmentObject(favorites)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Search")
        .onAppear {
            vm.setRepository(repo)     // 🔥 GARANTE QUE A SEARCH USA O REPO REAL
        }
    }
}
