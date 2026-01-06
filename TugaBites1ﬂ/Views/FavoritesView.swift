import SwiftUI

struct FavoritesView: View {

    // Repositório principal da app (todas as receitas)
    @EnvironmentObject var repo: LocalRecipeRepository

    // Store responsável por gerir os favoritos
    @EnvironmentObject var favorites: FavoritesStore

    // MARK: - Colors
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    // MARK: - Derived Data
    // As receitas favoritas são calculadas a partir do repo + IDs guardados
    private var favoriteRecipes: [Recipe] {
        repo.recipes.filter { favorites.favoriteIDs.contains($0.id) }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {

            // Estado vazio quando não existem favoritos
            if favoriteRecipes.isEmpty {
                emptyState
            } else {

                // Lista de favoritos reutilizando o mesmo card da Home
                VStack(spacing: 18) {
                    ForEach(favoriteRecipes) { recipe in
                        NavigationLink(value: recipe) {
                            HomeRecipeCard(
                                recipe: recipe,
                                compact: false
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
        }
        .background(backgroundBeige.ignoresSafeArea())
        .navigationTitle("Your Favorites ❤️")
    }

    // MARK: - Empty State
    // Feedback visual simples quando o utilizador ainda não tem favoritos
    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("No favorites yet!")
                .font(.system(size: 20, weight: .bold))

            Text("Save your favourite Portuguese recipes ❤️")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}

