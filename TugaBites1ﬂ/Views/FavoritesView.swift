
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    @EnvironmentObject var favorites: FavoritesStore
    @StateObject private var vm: FavoritesViewModel

    init() {
        _vm = StateObject(wrappedValue: FavoritesViewModel(repo: LocalRecipeRepository(), favs: FavoritesStore()))
    }

    var body: some View {
        List(vm.items) { recipe in
            NavigationLink(value: recipe) {
                RecipeRow(recipe: recipe)
            }
        }
        .navigationTitle("Favorites")
    }
}
