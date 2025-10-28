//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 4/5/2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    // MARK: - Base URLs
    private let searchURL = "https://www.themealdb.com/api/json/v1/1/search.php?f=a"
    private let categoryListURL = "https://www.themealdb.com/api/json/v1/1/list.php?c=list"
    private let mealsByCategoryBaseURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    private let mealDetailBaseURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="

    // MARK: - Fetch All Meals
    func getMeals(completed: @escaping (Result<[Meal], APError>) -> Void) {
        guard let url = URL(string: searchURL) else {
            completed(.failure(.invalidUrl))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                completed(.success(decodedResponse.meals ?? []))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    // MARK: - Fetch Meals by Category
    func getMealsByCategory(_ category: String, completed: @escaping (Result<[Meal], APError>) -> Void) {
        let urlString = "\(mealsByCategoryBaseURL)\(category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidUrl))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                completed(.success(decodedResponse.meals ?? []))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    // MARK: - Fetch All Categories
    func getCategories(completed: @escaping (Result<[String], APError>) -> Void) {
        guard let url = URL(string: categoryListURL) else {
            completed(.failure(.invalidUrl))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CategoryListResponse.self, from: data)
                let categories = decodedResponse.meals.map { $0.strCategory }
                completed(.success(categories))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    // MARK: - Fetch Meal Detail
    func getMealDetail(id: String, completed: @escaping (Result<MealDetail, APError>) -> Void) {
        let detailURL = "\(mealDetailBaseURL)\(id)"
        guard let url = URL(string: detailURL) else {
            completed(.failure(.invalidUrl))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
                if let mealDetail = decodedResponse.meals.first {
                    completed(.success(mealDetail))
                } else {
                    completed(.failure(.invalidData))
                }
            } catch {
                print("Detail decode error:", error)
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}

extension NetworkManager {
    func getMealsByCategory(_ category: String) async -> [Meal]? {
        await withCheckedContinuation { continuation in
            getMealsByCategory(category) { result in
                switch result {
                case .success(let meals): continuation.resume(returning: meals)
                case .failure: continuation.resume(returning: nil)
                }
            }
        }
    }

    func searchMealsByName(_ name: String) async -> [Meal]? {
        await withCheckedContinuation { continuation in
            let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(encoded)") else {
                continuation.resume(returning: nil)
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    continuation.resume(returning: nil)
                    return
                }
                let decoded = try? JSONDecoder().decode(MealResponse.self, from: data)
                continuation.resume(returning: decoded?.meals)
            }.resume()
        }
    }
}
