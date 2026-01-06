import SwiftUI

struct HomeView: View {

    // Repository partilhado com a app (fonte única de dados)
    @EnvironmentObject var repo: LocalRecipeRepository

    // MARK: - Colors
    // Paleta usada de forma consistente em toda a app
    private let darkGreen = Color(red: 0.18, green: 0.30, blue: 0.25)
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    // Estado local apenas para animação de entrada
    @State private var appear = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 36) {

                // MARK: - Header
                // Animação simples para dar entrada suave ao ecrã
                header
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 10)

                // MARK: - Trending Section
                // Mostra apenas se existirem receitas carregadas
                if !repo.recipes.isEmpty {
                    sectionTitle("Trending")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {

                            // Destaque apenas das primeiras receitas
                            ForEach(repo.recipes.prefix(7)) { recipe in
                                NavigationLink(value: recipe) {
                                    HomeRecipeCard(
                                        recipe: recipe,
                                        compact: true
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // MARK: - All Recipes Section
                sectionTitle("Suggestions recipes")

                VStack(spacing: 18) {
                    ForEach(repo.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            HomeRecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, 24) // evita conflito visual com a TabBar
        }
        .background(backgroundBeige.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)

        // MARK: - OnAppear Animation
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                appear = true
            }
        }
    }

    // MARK: - Header Component
    // Identidade visual simples da app
    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TugaBites")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(darkGreen)

            Text("Portuguese recipes, made simple")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    // MARK: - Section Title Component
    // Reutilizável para manter consistência visual
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(darkGreen)
            .padding(.horizontal)
    }
}
