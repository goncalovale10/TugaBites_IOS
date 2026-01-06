import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @EnvironmentObject var favorites: FavoritesStore

    // MARK: - COLORS
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    // 🔥 receitas favoritas derivadas
    private var favoriteRecipes: [Recipe] {
        repo.recipes.filter { favorites.favoriteIDs.contains($0.id) }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {

            if favoriteRecipes.isEmpty {
                emptyState
            } else {
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

    // MARK: - EMPTY STATE
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
