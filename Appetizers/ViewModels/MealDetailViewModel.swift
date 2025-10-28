//
//  MealDetailViewModel.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import UIKit

final class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    @Published var alertItem: AlertItem?
    
    func getMealDetail(for id: String) {
        NetworkManager.shared.getMealDetail(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.mealDetail = detail
                case .failure(let error):
                    switch error {
                    case .invalidUrl:
                        self.alertItem = AlertContext.InvalidURL
                    case .invalidResponse:
                        self.alertItem = AlertContext.InvalidResponse
                    case .invalidData:
                        self.alertItem = AlertContext.InvalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
}
