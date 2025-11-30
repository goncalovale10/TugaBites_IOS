import SwiftUI

struct HomeRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            
            // IMAGEM
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            
            // CAIXA VERDE
            VStack(spacing: 8) {
                
                // ÍCONES
                HStack(spacing: 24) {
                    Label("\(recipe.calories) kcal", systemImage: "flame")
                    Label("\(recipe.prepTimeMinutes) min", systemImage: "clock")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                
                // TÍTULO
                Text(recipe.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Color("GreenPrimary"))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .offset(y: -18)
        }
        .padding(.bottom, -18)
    }
}
