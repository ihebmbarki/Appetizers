//
//  MealPickerView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import SwiftUI

struct MealPickerView: View {
    let meals: [Meal] = []
    var onSelect: (Meal) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(meals) { meal in
                Button(action: {
                    onSelect(meal)
                    dismiss()
                }) {
                    HStack {
                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        
                        Text(meal.strMeal)
                            .font(.body)
                            .padding(.leading, 8)
                    }
                }
            }
            .navigationTitle("Pick a Meal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
