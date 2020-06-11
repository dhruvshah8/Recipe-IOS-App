
import Foundation

struct Home {
    static let categories = [
        Category(title: "breakfast", query: "breakfast"),
        Category(title: "lunch", query: "lunch"),
        Category(title: "dinner", query: "dinner"),
        Category(title: "smoothie", query: "smoothie"),
        Category(title: "dessert", query: "dessert")
    ]
}

struct Category {
    let title: String
    let query: String
}
