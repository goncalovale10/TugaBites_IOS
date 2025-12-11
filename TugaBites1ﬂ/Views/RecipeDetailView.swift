import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // NOME DA RECEITA
                Text(recipe.name)
                    .font(.largeTitle.bold())
                    .foregroundColor(Color("GreenDark"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // IMAGEM + FAVORITO
                ZStack(alignment: .topTrailing) {
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                    Button {
                        favorites.toggle(recipe)
                    } label: {
                        Image(systemName: favorites.isFavorite(recipe) ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(.trailing, 26)
                            .padding(.top, 12)
                    }
                }

                // TEMPO + KCAL
                HStack(spacing: 20) {
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)

                // INGREDIENTES
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.title2.bold())

                    ForEach(recipe.ingredients, id: \.self) { ing in
                        Text("• \(ing)")
                    }
                }
                .padding(.horizontal)

                // STEPS
                VStack(alignment: .leading, spacing: 10) {
                    Text("Steps")
                        .font(.title2.bold())

                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .bold()
                            Text(step)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 32)
            }
        }
        .background(Color("BackgroundBeige").ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
