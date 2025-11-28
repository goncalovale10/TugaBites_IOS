
import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var favorites: FavoritesStore
    @StateObject private var vm = RecipeDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(recipe.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(alignment: .topTrailing) {
                        Button {
                            favorites.toggle(recipe)
                        } label: {
                            Image(systemName: favorites.isFavorite(recipe) ? "heart.fill" : "heart")
                                .padding(8)
                                .background(.thinMaterial)
                                .clipShape(Circle())
                                .padding()
                        }
                    }

                HStack(spacing: 16) {
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Text("Ingredients")
                    .font(.title2.bold())
                ForEach(recipe.ingredients) { ing in
                    HStack {
                        Text("• \(ing.name)")
                        Spacer()
                        Text(ing.quantity).foregroundStyle(.secondary)
                    }
                    .font(.body)
                }

                Text("Steps")
                    .font(.title2.bold())
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { idx, step in
                        HStack(alignment: .top) {
                            Text("\(idx + 1).").bold()
                            Text(step)
                        }
                    }
                }

                Group {
                    Text("Cooking Timer")
                        .font(.title2.bold())
                    HStack(spacing: 12) {
                        Button("Start \(recipe.prepTimeMinutes) min") {
                            vm.startTimer(minutes: recipe.prepTimeMinutes)
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Stop") { vm.stopTimer() }
                            .buttonStyle(.bordered)
                        Spacer()
                        Text(formatTime(vm.remainingSeconds))
                            .monospacedDigit()
                            .font(.title3.bold())
                    }
                }
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatTime(_ sec: Int) -> String {
        let m = sec / 60
        let s = sec % 60
        return String(format: "%02d:%02d", m, s)
    }
}
