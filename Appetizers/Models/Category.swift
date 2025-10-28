//
//  Category.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import Foundation

struct CategoryListResponse: Codable {
    let meals: [CategoryItem]
}

struct CategoryItem: Codable {
    let strCategory: String
}
