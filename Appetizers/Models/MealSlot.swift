//
//  MealSlot.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import Foundation

struct MealSlot: Identifiable, Codable {
    let id = UUID()
    var meal: Meal?
    var type: MealType
}

enum MealType: String, Codable {
    case breakfast, lunch, dinner
}

struct DayPlan: Identifiable, Codable {
    let id = UUID()
    let dayName: String
    var slots: [MealSlot]
}
