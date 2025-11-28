
import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }

                RecipeListView()
                    .tabItem { Label("Recipes", systemImage: "list.bullet") }

                SearchView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }

                FavoritesView()
                    .tabItem { Label("Favorites", systemImage: "heart") }
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
}
