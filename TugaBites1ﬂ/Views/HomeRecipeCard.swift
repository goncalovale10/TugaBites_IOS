import SwiftUI

struct HomeRecipeCard: View {

    // Receita a apresentar
    let recipe: Recipe

    // Define se o card é usado em modo compacto (ex: Trending)
    var compact: Bool = false

    // MARK: - Layout Constants
    // Dimensões variam consoante o contexto de utilização
    private var cardHeight: CGFloat {
        compact ? 150 : 190
    }

    private var cardWidth: CGFloat {
        compact ? 260 : UIScreen.main.bounds.width - 32
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // MARK: - Image
            // Tamanho fixo para garantir espaçamento uniforme entre cards
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()

            // MARK: - Gradient Overlay
            // Melhora a legibilidade do texto sobre a imagem
            LinearGradient(
                colors: [
                    .black.opacity(0.0),
                    .black.opacity(0.65)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // MARK: - Content
            VStack(alignment: .leading, spacing: 8) {

                // Nome da receita (mantido em PT)
                Text(recipe.name)
                    .font(.system(size: compact ? 18 : 22, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                // Métricas principais da receita
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
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.16),
            radius: 12,
            x: 0,
            y: 8
        )
        .contentShape(Rectangle()) // melhora a área de toque
    }
}
