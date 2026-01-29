import Foundation

enum Category: String, Codable, CaseIterable, Identifiable {
    case appetizer = "Appetizer"
    case snack = "Snack"
    case soup = "Soup"
    case meat = "Meat"
    case fish = "Fish"
    case dessert = "Dessert"
    case other = "Other"

    var id: String { rawValue }

}

