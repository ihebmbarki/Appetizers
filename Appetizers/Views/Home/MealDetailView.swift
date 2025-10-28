//
//  MealDetailView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    @StateObject private var viewModel = MealDetailViewModel()
    
    var body: some View {
        ScrollView {
            if let detail = viewModel.mealDetail {
                VStack(alignment: .leading, spacing: 16) {
                    
                    AsyncImage(url: URL(string: detail.strMealThumb)) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 240)
                    .clipped()
                    .cornerRadius(12)
                    
                    Text(detail.strMeal)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Category: \(detail.strCategory ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Area: \(detail.strArea ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("🧂 Ingredients")
                        .font(.headline)
                    
                    ForEach(detail.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                    }
                    
                    Divider()
                    
                    DisclosureGroup("📖 Instructions") {
                        let steps = detail.strInstructions
                            .components(separatedBy: ". ")
                            .filter { !$0.isEmpty }

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(steps.indices, id: \.self) { index in
                                HStack(alignment: .top) {
                                    Text("\(index + 1).")
                                        .bold()
                                    Text(steps[index])
                                }
                            }
                        }
                        .padding(.top, 6)
                    }
                    .font(.body)
                    .padding(.vertical)

                    if let youtubeURL = detail.strYoutube, let url = URL(string: youtubeURL) {
                        Link("🎬 Watch on YouTube", destination: url)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top)
                    }
                }
                .padding()
            } else {
                ProgressView("Loading details…")
            }
        }
        .navigationTitle(meal.strMeal)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    FavoritesManager.shared.toggleFavorite(meal)
                } label: {
                    Image(systemName: FavoritesManager.shared.isFavorite(meal) ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            viewModel.getMealDetail(for: meal.idMeal)
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

