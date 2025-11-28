import Foundation

struct Recipe: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let imageName: String
    let category: Category
    let prepTimeMinutes: Int
    let calories: Int
    let ingredients: [String]
    let steps: [String]
    let isPortugueseClassic: Bool

    init(
        id: Int,
        name: String,
        imageName: String,
        category: Category,
        prepTimeMinutes: Int,
        calories: Int,
        ingredients: [String],
        steps: [String],
        isPortugueseClassic: Bool = true
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.category = category
        self.prepTimeMinutes = prepTimeMinutes
        self.calories = calories
        self.ingredients = ingredients
        self.steps = steps
        self.isPortugueseClassic = isPortugueseClassic
    }
}
