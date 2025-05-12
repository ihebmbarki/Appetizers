//
//  Appetizer.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 25/4/2025.
//

import Foundation

struct Appetizer: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let imageURL: String
    let calories: Int
    let protein: Int
    let carbs: Int
}

struct AppetizerResponse: Decodable {
    let request: [Appetizer]
}

struct MockData {
    static let sampleAppetizer = Appetizer(id: 0001,
                                           name: "Test Appetizer",
                                           description: "This is a description for my appetier",
                                           price: 9.99,
                                           imageURL: "listing-4",
                                           calories:250,
                                           protein: 20,
                                           carbs: 60)
    static let appetizers = [sampleAppetizer, sampleAppetizer, sampleAppetizer, sampleAppetizer]
}
