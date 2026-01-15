import SwiftUI

// Card reutilizável para apresentar uma receita na Home
struct HomeRecipeCard: View {

    // Receita a ser apresentada no card
    let recipe: Recipe

    // Define se o card é compacto (ex: secção Trending)
    var compact: Bool = false

    // MARK: - Layout Constants

    // Altura do card (varia consoante o modo compacto)
    private var cardHeight: CGFloat {
        compact ? 150 : 190
    }

    // Largura do card (fixa no Trending e dinâmica no resto)
    private var cardWidth: CGFloat {
        compact ? 260 : UIScreen.main.bounds.width - 32
    }

    var body: some View {

        // Sobreposição de imagem, gradiente e conteúdo
        ZStack(alignment: .bottomLeading) {

            // Imagem da receita (fundo do card)
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()

            // Gradiente para melhorar a leitura do texto
            LinearGradient(
                colors: [
                    .black.opacity(0.0),
                    .black.opacity(0.65)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Conteúdo textual do card
            VStack(alignment: .leading, spacing: 8) {

                // Nome da receita
                Text(recipe.name)
                    .font(.system(size: compact ? 18 : 22, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                // Tempo de preparação e calorias
                HStack(spacing: 14) {
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }

        // Dimensão final do card
        .frame(width: cardWidth, height: cardHeight)

        // Cantos arredondados
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )

        // Sombra para dar profundidade
        .shadow(
            color: .black.opacity(0.16),
            radius: 12,
            x: 0,
            y: 8
        )

        // Expande a área de toque do card
        .contentShape(Rectangle())
    }
}
