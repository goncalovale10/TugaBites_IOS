import SwiftUI

struct RecipeDetailView: View {

    // Receita a apresentar
    let recipe: Recipe

    // Store responsável pelos favoritos (estado global)
    @EnvironmentObject var favorites: FavoritesStore

    // Tab atualmente selecionada (ingredientes por defeito)
    @State private var selectedTab: Tab = .ingredients

    // Tabs disponíveis no detalhe da receita
    enum Tab {
        case ingredients
        case preparation
    }

    // MARK: - Colors
    private let greenDark = Color(red: 0.18, green: 0.30, blue: 0.25)
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    var body: some View {
        // Scroll vertical do conteúdo todo
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {

                // Imagem principal da receita (com botão de favorito por cima)
                heroImage

                // Nome + métricas (tempo e calorias)
                titleAndMetrics

                // Botões para trocar entre Ingredients e Preparation
                tabSwitcher
                    .padding(.horizontal)

                // Mostra a secção conforme a tab escolhida
                if selectedTab == .ingredients {
                    ingredientsSection
                } else {
                    preparationSection
                }

                Spacer(minLength: 24)
            }
            .padding(.top, 14)
        }
        // Fundo consistente com o resto da app
        .background(backgroundBeige.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero Image
    // Usa GeometryReader para calcular tamanho e manter proporção 4:3
    private var heroImage: some View {
        GeometryReader { geo in
            let width = geo.size.width - 32
            let height = width * 0.75

            ZStack(alignment: .topTrailing) {

                // Imagem da receita com cantos arredondados
                Image(recipe.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 28,
                            style: .continuous
                        )
                    )

                // Botão de favorito sobreposto à imagem
                Button {
                    favorites.toggle(recipe)
                } label: {
                    Image(systemName: favorites.isFavorite(recipe) ? "heart.fill" : "heart")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black.opacity(0.55))
                        .clipShape(Circle())
                }
                .padding(14)
            }
            .frame(width: geo.size.width, height: height)
        }
        // Define altura fixa para o GeometryReader não colapsar
        .frame(height: (UIScreen.main.bounds.width - 32) * 0.75)
        .padding(.horizontal, 16)
    }

    // MARK: - Title & Metrics
    private var titleAndMetrics: some View {
        VStack(spacing: 10) {

            // Nome da receita
            Text(recipe.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(greenDark)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Tempo + calorias
            HStack(spacing: 36) {
                metric(icon: "clock", value: "\(recipe.prepTimeMinutes) min")
                metric(icon: "flame", value: "\(recipe.calories) kcal")
            }
        }
    }

    // Componente pequeno reutilizável para métricas
    private func metric(icon: String, value: String) -> some View {
        Label(value, systemImage: icon)
            .font(.subheadline.weight(.medium))
            .foregroundColor(.secondary)
    }

    // MARK: - Tab Switcher
    private var tabSwitcher: some View {
        HStack(spacing: 4) {
            tabButton("Ingredients", .ingredients)
            tabButton("Preparation", .preparation)
        }
        .padding(4)
        .background(Color.secondary.opacity(0.12))
        .clipShape(Capsule())
    }

    // Botão individual da tab (muda selectedTab com animação)
    private func tabButton(_ title: String, _ tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(selectedTab == tab ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    selectedTab == tab ? greenDark : Color.clear
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sections

    // Lista simples de ingredientes (bullets)
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(recipe.ingredients, id: \.self) { item in
                Text("• \(item)")
                    .font(.system(size: 16))
            }
        }
        .sectionCard
    }

    // Lista de passos com numeração (1., 2., 3...)
    private var preparationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 10) {
                    Text("\(index + 1).")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(greenDark)

                    Text(step)
                        .font(.system(size: 16))
                }
            }
        }
        .sectionCard
    }
}

// MARK: - Section Card Style
// Extensão para aplicar o mesmo estilo “card” a Ingredients e Preparation
private extension View {
    var sectionCard: some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
            .shadow(
                color: .black.opacity(0.06),
                radius: 10,
                x: 0,
                y: 5
            )
            .padding(.horizontal, 16)
    }
}
