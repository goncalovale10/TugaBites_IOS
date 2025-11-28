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

    var icon: String {
        switch self {
        case .appetizer: return "takeoutbag.and.cup.and.straw"  
        case .snack: return "takeoutbag.and.cup.and.straw.fill"
        case .soup: return "bowl"
        case .meat: return "fork.knife"
        case .fish: return "fish"
        case .dessert: return "cupcake"
        case .other: return "sparkles"
        }
    }
}
