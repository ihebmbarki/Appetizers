//
//  AppetizerListViewModel.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 8/5/2025.
//

import SwiftUI

final class MealListViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var alertItem: AlertItem?
    @Published var categories: [String] = []
    @Published var selectedCategory: String? = nil
    @Published var featuredMeal: Meal?
    
    func getMeals() {
        NetworkManager.shared.getMeals { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self.meals = meals
                case .failure(let error):
                    switch error {
                    case .invalidResponse:
                        self.alertItem = AlertContext.InvalidResponse
                    case .invalidUrl:
                        self.alertItem = AlertContext.InvalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.InvalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
    
    func getCategories() {
        // Optional: Load categories via API or mock data for now
        self.categories = ["All", "Breakfast", "Side", "Dessert", "Beef", "Pork", "Chicken", "Seafood"]
    }
    
    func filterMeals(by category: String) {
        if category == "All" {
            getMeals()
        } else {
            NetworkManager.shared.getMealsByCategory(category) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let meals):
                        self.meals = meals
                    case .failure:
                        self.alertItem = AlertContext.InvalidData
                    }
                }
            }
        }
    }
}
