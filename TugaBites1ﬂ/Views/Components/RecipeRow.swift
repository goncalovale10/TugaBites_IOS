import SwiftUI

// Linha reutilizável para mostrar uma receita numa lista (ex: Home / Search / Favorites)
struct RecipeRow: View {
    // Receita a apresentar nesta linha
    let recipe: Recipe

    // Store global com os favoritos (injetado via EnvironmentObject)
    @EnvironmentObject var favorites: FavoritesStore

    // Computed property: diz se esta receita está marcada como favorita
    private var isFav: Bool { favorites.isFavorite(recipe) }

    // Estado para controlar a animação “burst” (dispara quando adiciona aos favoritos)
    @State private var burstID: Int = 0
    @State private var showBurst: Bool = false

    var body: some View {
        // Layout horizontal: imagem à esquerda, texto ao meio, botão à direita
        HStack(spacing: 12) {

            // Imagem da receita com um badge fixo no canto superior direito quando é favorita
            ZStack(alignment: .topTrailing) {

                // Imagem da receita (vinda dos Assets pelo nome recipe.imageName)
                Image(recipe.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 62, height: 62)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                // Se for favorita, mostra o badge + animação “burst”
                if isFav {
                    FavoriteBadge(burstID: burstID, showBurst: showBurst)
                        .padding(6)
                        // Transição de entrada/saída do badge (escala + opacidade)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.7).combined(with: .opacity),
                                removal: .scale(scale: 0.85).combined(with: .opacity)
                            )
                        )
                }
            }
            // Animação geral quando isFav muda (aplica-se ao container do badge/imagem)
            .animation(.spring(response: 0.28, dampingFraction: 0.78), value: isFav)

            // Zona de texto: nome + info (tempo e calorias)
            VStack(alignment: .leading, spacing: 6) {

                // Nome da receita
                Text(recipe.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                // Tempo e calorias com ícones (clock e flame)
                HStack(spacing: 10) {
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            }

            // Empurra o botão de favorito para o lado direito
            Spacer()

            // Botão de favorito (coração)
            Button {

                // Guarda o estado anterior para saber se vai passar a favorito agora
                let wasFav = isFav

                // Alterna favorito com animação
                withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                    favorites.toggle(recipe)
                }

                // Só dispara “burst” quando a receita passa de não-favorita para favorita
                if !wasFav {
                    // Muda burstID para forçar o FavoriteBadge a disparar a animação
                    burstID += 1
                    // Ativa “pulse” no badge
                    showBurst = true

                    // Desliga o “pulse” após ~0.55s (o badge continua visível)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                        showBurst = false
                    }
                }

            } label: {

                // Ícone do coração muda conforme isFav
                Image(systemName: isFav ? "heart.fill" : "heart")
                    .foregroundColor(isFav ? .red : .secondary)
                    .font(.system(size: 18, weight: .semibold))
                    // Transição suave quando o símbolo troca
                    .contentTransition(.symbolEffect(.replace))
                    // Efeito bounce quando muda (iOS 17+)
                    .symbolEffect(.bounce, value: isFav)
            }
            .buttonStyle(.plain)
        }

        // Estilo “card” da linha
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Badge Premium (fixo) + Burst (quando marca favorito)
private struct FavoriteBadge: View {
    // Identificador do burst: quando muda, dispara o runBurst()
    let burstID: Int

    // Controla um “pulse” no badge (ligeiro scale) enquanto o burst está ativo
    let showBurst: Bool

    // Estado do anel (ripple/halo)
    @State private var ringScale: CGFloat = 0.6
    @State private var ringOpacity: Double = 0.0

    // Partícula 1: offset/opacidade/escala
    @State private var p1Offset: CGSize = .zero
    @State private var p1Opacity: Double = 0.0
    @State private var p1Scale: CGFloat = 0.6

    // Partícula 2
    @State private var p2Offset: CGSize = .zero
    @State private var p2Opacity: Double = 0.0
    @State private var p2Scale: CGFloat = 0.6

    // Partícula 3
    @State private var p3Offset: CGSize = .zero
    @State private var p3Opacity: Double = 0.0
    @State private var p3Scale: CGFloat = 0.6

    var body: some View {
        ZStack {

            // Halo/ripple (só visível durante o burst)
            Circle()
                .strokeBorder(Color.red.opacity(0.35), lineWidth: 2)
                .frame(width: 26, height: 26)
                .scaleEffect(ringScale)
                .opacity(ringOpacity)

            // Badge fixo com efeito “glass”
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 22, height: 22)
                    .shadow(color: .black.opacity(0.14), radius: 6, x: 0, y: 3)

                Image(systemName: "heart.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red)
                    .shadow(color: .black.opacity(0.08), radius: 1, x: 0, y: 1)
            }
            // Pequeno “pulse” quando showBurst é true
            .scaleEffect(showBurst ? 1.12 : 1.0)
            .animation(.spring(response: 0.22, dampingFraction: 0.6), value: showBurst)

            // Partículas (3 mini corações) que se movem durante o burst
            ParticleHeart(offset: p1Offset, opacity: p1Opacity, scale: p1Scale, size: 10)
            ParticleHeart(offset: p2Offset, opacity: p2Opacity, scale: p2Scale, size: 9)
            ParticleHeart(offset: p3Offset, opacity: p3Opacity, scale: p3Scale, size: 8)
        }
        // Sempre que burstID muda, corre a animação burst
        .onChange(of: burstID) {
            runBurst()
        }
    }

    // Executa a sequência de animações do “burst”
    private func runBurst() {

        // Reset dos estados para começar sempre do mesmo ponto
        ringScale = 0.6
        ringOpacity = 0.0

        p1Offset = .zero; p1Opacity = 0.0; p1Scale = 0.6
        p2Offset = .zero; p2Opacity = 0.0; p2Scale = 0.6
        p3Offset = .zero; p3Opacity = 0.0; p3Scale = 0.6

        // RING: aparece e expande (fase 1)
        withAnimation(.easeOut(duration: 0.18)) {
            ringOpacity = 1.0
            ringScale = 1.15
        }

        // RING: desaparece e continua a expandir (fase 2 com delay)
        withAnimation(.easeOut(duration: 0.28).delay(0.12)) {
            ringOpacity = 0.0
            ringScale = 1.55
        }

        // Partículas: ganham opacidade/escala e “sobem” com spring
        withAnimation(.spring(response: 0.26, dampingFraction: 0.65)) {
            p1Opacity = 1.0; p1Scale = 1.0; p1Offset = CGSize(width: 10, height: -18)
            p2Opacity = 1.0; p2Scale = 1.0; p2Offset = CGSize(width: -12, height: -16)
            p3Opacity = 1.0; p3Scale = 1.0; p3Offset = CGSize(width: 2, height: -22)
        }

        // Partículas: fade out + encolhe depois de um pequeno delay
        withAnimation(.easeOut(duration: 0.26).delay(0.18)) {
            p1Opacity = 0.0; p1Scale = 0.7
            p2Opacity = 0.0; p2Scale = 0.7
            p3Opacity = 0.0; p3Scale = 0.7
        }
    }
}

// View pequena reutilizável para cada “partícula” (mini coração)
private struct ParticleHeart: View {
    let offset: CGSize
    let opacity: Double
    let scale: CGFloat
    let size: CGFloat

    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: size, weight: .bold))
            .foregroundColor(.red.opacity(0.85))
            .shadow(color: .black.opacity(0.10), radius: 4, x: 0, y: 2)
            .offset(offset)
            .opacity(opacity)
            .scaleEffect(scale)
            // Impede que estas partículas “apanhem” toques
            .allowsHitTesting(false)
    }
}
