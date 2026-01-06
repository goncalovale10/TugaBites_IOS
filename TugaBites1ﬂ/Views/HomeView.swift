import SwiftUI

struct HomeView: View {
    @EnvironmentObject var repo: LocalRecipeRepository

    // MARK: - COLORS
    private let darkGreen = Color(red: 0.18, green: 0.30, blue: 0.25)
    private let backgroundBeige = Color(red: 0.96, green: 0.94, blue: 0.90)

    @State private var appear = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 36) {

                // MARK: - HEADER
                header
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 10)

                // MARK: - TRENDING
                if !repo.recipes.isEmpty {
                    sectionTitle("Trending")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
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

                // MARK: - ALL RECIPES
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
            .padding(.bottom, 24) // evita colisão com tab bar
        }
        .background(backgroundBeige.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                appear = true
            }
        }
    }

    // MARK: - HEADER
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

    // MARK: - SECTION TITLE
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(darkGreen)
            .padding(.horizontal)
    }
}
