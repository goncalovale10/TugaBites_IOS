
import Foundation
import Combine

protocol RecipeRepository: ObservableObject {
    var recipes: [Recipe] { get }
    func reload()
}

final class LocalRecipeRepository: RecipeRepository {
    @Published private(set) var recipes: [Recipe] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        reload()
    }

    func reload() {
        if let url = Bundle.main.url(forResource: "recipes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([Recipe].self, from: data)
                self.recipes = decoded
            } catch {
                print("Failed to load recipes.json: \(error)")
                self.recipes = []
            }
        } else {
            print("recipes.json not found in bundle")
            self.recipes = []
        }
    }
}
