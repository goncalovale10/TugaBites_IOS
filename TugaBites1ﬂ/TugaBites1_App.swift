import SwiftUI

@main
struct TugaBites1_App: App {
    @StateObject private var repo = LocalRecipeRepository()
    @StateObject private var favorites = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(repo)
                .environmentObject(favorites)
        }
    }
}
