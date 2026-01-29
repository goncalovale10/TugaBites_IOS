import Foundation
import Combine

/// Protocolo base para qualquer fonte de receitas
protocol RecipeRepository: ObservableObject {
    var recipes: [Recipe] { get }
    func reload()
}

/// Implementação local que carrega receitas a partir de um ficheiro JSON
final class LocalRecipeRepository: RecipeRepository {

    @Published private(set) var recipes: [Recipe] = []

    private let bundle: Bundle
    private let resourceName: String

    init(
        bundle: Bundle = .main,
        resourceName: String = "recipes"
    ) {
        self.bundle = bundle
        self.resourceName = resourceName
        reload()
    }

    /// Recarrega as receitas a partir do ficheiro JSON
    func reload() {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            print("❌ ERROR: \(resourceName).json not found in bundle.")
            recipes = []
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Recipe].self, from: data)
            recipes = decoded
        } catch {
            print("❌ JSON DECODING ERROR:", error)
            recipes = []
        }
    }
}
