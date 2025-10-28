//
//  OrderView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 21/4/2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favorites = FavoritesManager.shared
    
    var body: some View {
        NavigationView {
            if favorites.meals.isEmpty {
                Text("No favorites yet 💔")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(favorites.meals) { meal in
                    NavigationLink(destination: MealDetailView(meal: meal)) {
                        MealListCell(meal: meal)
                    }
                }
                .navigationTitle("❤️ Favorites")
            }
        }
    }
}

#Preview {
    FavoritesView()
}
