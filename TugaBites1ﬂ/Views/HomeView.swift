
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var repo: LocalRecipeRepository

    let grid = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 16) {
                ForEach(repo.recipes.prefix(6)) { recipe in
                    NavigationLink(value: recipe) {
                        VStack(alignment: .leading, spacing: 8) {
                            Image(recipe.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 120)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(recipe.title)
                                .font(.subheadline).bold()
                                .lineLimit(2)
                            HStack(spacing: 8) {
                                Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                                Label("\(recipe.calories) kcal", systemImage: "flame")
                            }
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("TugaBites")
    }
}
