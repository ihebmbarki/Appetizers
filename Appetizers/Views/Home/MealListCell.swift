//
//  AppetizerListCell.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 3/5/2025.
//

import SwiftUI

struct MealListCell: View {
    let meal: Meal

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 90)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 120, height: 90)
            }

            Text(meal.strMeal)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.leading)

            Spacer()
        }
    }
}


