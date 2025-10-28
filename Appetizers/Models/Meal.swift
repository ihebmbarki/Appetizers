//
//  Appetizer.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 25/4/2025.
//

import Foundation

struct MealResponse: Decodable {
    let meals: [Meal]?
}

struct Meal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}
