import SwiftUI

struct HomeRecipeCard: View {
    let recipe: Recipe
    var compact: Bool = false

    // MARK: - Layout constants
    private var cardHeight: CGFloat {
        compact ? 150 : 190
    }

    private var cardWidth: CGFloat {
        compact ? 260 : UIScreen.main.bounds.width - 32
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // IMAGE (largura + altura fixas → espaçamento uniforme)
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()

            // GRADIENT
            LinearGradient(
                colors: [
                    .black.opacity(0.0),
                    .black.opacity(0.65)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // CONTENT
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name) // 🇵🇹 mantém PT
                    .font(.system(size: compact ? 18 : 22, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                HStack(spacing: 14) {
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.16), radius: 12, x: 0, y: 8)
        .contentShape(Rectangle())
    }
}
