import SwiftUI

struct HomeView: View {
    @EnvironmentObject var repo: LocalRecipeRepository
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // TÍTULO
                Text("Recipes Suggestions")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("GreenDark"))
                    .padding(.horizontal)
                
                // LISTA DE RECEITAS (APENAS 3 PARA COMEÇAR)
                VStack(spacing: 24) {
                    ForEach(repo.recipes.prefix(3)) { recipe in
                        NavigationLink(value: recipe) {
                            HomeRecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.top, 12)
        }
        .background(Color("BackgroundBeige").ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
