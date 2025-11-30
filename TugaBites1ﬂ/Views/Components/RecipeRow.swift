import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        HStack(spacing: 12) {

            // IMAGEM
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .topTrailing) {
                    if favorites.isFavorite(recipe) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(6)
                    }
                }
                .clipped()

            // TÍTULO + INFO
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)      // <-- CORRIGIDO
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            // BOTÃO FAVORITO
            Button {
                favorites.toggle(recipe)
            } label: {
                Image(systemName: favorites.isFavorite(recipe) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .imageScale(.large)
            }
            .buttonStyle(.borderless)
        }
    }
}
