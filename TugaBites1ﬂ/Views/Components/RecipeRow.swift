import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @EnvironmentObject var favorites: FavoritesStore

    // Estado favorito
    private var isFav: Bool { favorites.isFavorite(recipe) }

    // Animações (burst)
    @State private var burstID: Int = 0
    @State private var showBurst: Bool = false

    var body: some View {
        HStack(spacing: 12) {

            // IMAGEM + BADGE FIXO NO CANTO (premium)
            ZStack(alignment: .topTrailing) {
                Image(recipe.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 62, height: 62)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                if isFav {
                    FavoriteBadge(burstID: burstID, showBurst: showBurst)
                        .padding(6)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.7).combined(with: .opacity),
                                removal: .scale(scale: 0.85).combined(with: .opacity)
                            )
                        )
                }
            }
            .animation(.spring(response: 0.28, dampingFraction: 0.78), value: isFav)

            // TEXTO
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                HStack(spacing: 10) {
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            }

            Spacer()

            // BOTÃO FAVORITO
            Button {
                let wasFav = isFav

                withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                    favorites.toggle(recipe)
                }

                // Só dispara “wow burst” quando passa a favorito
                if !wasFav {
                    burstID += 1
                    showBurst = true

                    // termina o burst (o badge continua)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                        showBurst = false
                    }
                }
            } label: {
                Image(systemName: isFav ? "heart.fill" : "heart")
                    .foregroundColor(isFav ? .red : .secondary)
                    .font(.system(size: 18, weight: .semibold))
                    .contentTransition(.symbolEffect(.replace))
                    .symbolEffect(.bounce, value: isFav) // iOS 17+
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Badge Premium (fixo) + Burst (quando marca favorito)
private struct FavoriteBadge: View {
    let burstID: Int
    let showBurst: Bool

    @State private var ringScale: CGFloat = 0.6
    @State private var ringOpacity: Double = 0.0

    @State private var p1Offset: CGSize = .zero
    @State private var p1Opacity: Double = 0.0
    @State private var p1Scale: CGFloat = 0.6

    @State private var p2Offset: CGSize = .zero
    @State private var p2Opacity: Double = 0.0
    @State private var p2Scale: CGFloat = 0.6

    @State private var p3Offset: CGSize = .zero
    @State private var p3Opacity: Double = 0.0
    @State private var p3Scale: CGFloat = 0.6

    var body: some View {
        ZStack {
            // Ripple / halo (só quando dá like)
            Circle()
                .strokeBorder(Color.red.opacity(0.35), lineWidth: 2)
                .frame(width: 26, height: 26)
                .scaleEffect(ringScale)
                .opacity(ringOpacity)

            // Badge fixo “glass”
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
            .scaleEffect(showBurst ? 1.12 : 1.0)
            .animation(.spring(response: 0.22, dampingFraction: 0.6), value: showBurst)

            // Micro-partículas (3 mini corações)
            ParticleHeart(offset: p1Offset, opacity: p1Opacity, scale: p1Scale, size: 10)
            ParticleHeart(offset: p2Offset, opacity: p2Opacity, scale: p2Scale, size: 9)
            ParticleHeart(offset: p3Offset, opacity: p3Opacity, scale: p3Scale, size: 8)
        }
        // dispara sempre que burstID muda (quando marca favorito)
        .onChange(of: burstID) {
            runBurst()
        }
    }

    private func runBurst() {
        // reset rápido
        ringScale = 0.6
        ringOpacity = 0.0

        p1Offset = .zero; p1Opacity = 0.0; p1Scale = 0.6
        p2Offset = .zero; p2Opacity = 0.0; p2Scale = 0.6
        p3Offset = .zero; p3Opacity = 0.0; p3Scale = 0.6

        // RING: aparece e expande
        withAnimation(.easeOut(duration: 0.18)) {
            ringOpacity = 1.0
            ringScale = 1.15
        }
        withAnimation(.easeOut(duration: 0.28).delay(0.12)) {
            ringOpacity = 0.0
            ringScale = 1.55
        }

        // Partículas: sobem + fade
        withAnimation(.spring(response: 0.26, dampingFraction: 0.65)) {
            p1Opacity = 1.0; p1Scale = 1.0; p1Offset = CGSize(width: 10, height: -18)
            p2Opacity = 1.0; p2Scale = 1.0; p2Offset = CGSize(width: -12, height: -16)
            p3Opacity = 1.0; p3Scale = 1.0; p3Offset = CGSize(width: 2, height: -22)
        }
        withAnimation(.easeOut(duration: 0.26).delay(0.18)) {
            p1Opacity = 0.0; p1Scale = 0.7
            p2Opacity = 0.0; p2Scale = 0.7
            p3Opacity = 0.0; p3Scale = 0.7
        }
    }
}

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
            .allowsHitTesting(false)
    }
}
