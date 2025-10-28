//
//  FavoritesManager.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var meals: [Meal] = [] {
        didSet {
            saveFavorites()
        }
    }
    
    private let saveKey = "favoriteMeals"
    
    private init() {
        loadFavorites()
    }
    
    func toggleFavorite(_ meal: Meal) {
        if isFavorite(meal) {
            meals.removeAll { $0.idMeal == meal.idMeal }
        } else {
            meals.append(meal)
        }
    }
    
    func isFavorite(_ meal: Meal) -> Bool {
        meals.contains { $0.idMeal == meal.idMeal }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Meal].self, from: data) {
            meals = decoded
        }
    }
}
