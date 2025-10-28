//
//  AppetizerListView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 21/4/2025.
//

import SwiftUI

struct MealListView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var searchText = ""
    @State private var showFilters = false
    
    var filteredMeals: [Meal] {
        if searchText.isEmpty {
            return viewModel.meals
        } else {
            return viewModel.meals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(colors: [.orange.opacity(0.1), .yellow.opacity(0.05)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Header
                        headerSection
                        
                        // MARK: - Search bar
                        searchBar
                        
                        // MARK: - Categories
                        categoryScroll
                        
                        // MARK: - Meals Grid
                        mealGrid
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await refreshMeals()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.getMeals()
                viewModel.getCategories()
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
        }
    }
    
    @MainActor
    func refreshMeals() async {
        viewModel.getMeals()
        viewModel.getCategories()
        
        // Pick a new featured meal randomly
        viewModel.featuredMeal = viewModel.meals.randomElement()
    }
}

// MARK: - Header
private extension MealListView {
    var headerSection: some View {
          VStack(alignment: .leading, spacing: 8) {
              Text("WHAT TO EAT ? 🍽")
                  .font(.largeTitle.bold())
              
              Text("Hand-picked recipes for every mood")
                  .font(.subheadline)
                  .foregroundColor(.gray)
              
              if let featuredMeal = viewModel.featuredMeal {
                  NavigationLink(destination: MealDetailView(meal: featuredMeal)) {
                      AsyncImage(url: URL(string: featuredMeal.strMealThumb)) { image in
                          image
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(height: 220)
                              .cornerRadius(16)
                              .overlay(
                                  LinearGradient(
                                      gradient: Gradient(colors: [.black.opacity(0.6), .clear]),
                                      startPoint: .bottom,
                                      endPoint: .top
                                  )
                              )
                              .overlay(
                                  Text(featuredMeal.strMeal)
                                      .font(.title2.bold())
                                      .foregroundColor(.white)
                                      .padding(),
                                  alignment: .bottomLeading
                              )
                      } placeholder: {
                          ProgressView()
                              .frame(height: 220)
                      }
                  }
                  .buttonStyle(.plain)
              }
          }
          .padding(.horizontal)
      }
    // MARK: - Search Bar
    var searchBar: some View {
        HStack {
            TextField("Search meals...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            Button(action: { showFilters.toggle() }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
                    .padding(8)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Category Scroll
    var categoryScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Text(category)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(viewModel.selectedCategory == category ? Color.orange : Color(.systemGray5))
                        .foregroundColor(viewModel.selectedCategory == category ? .white : .black)
                        .cornerRadius(20)
                        .onTapGesture {
                            viewModel.selectedCategory = category
                            viewModel.filterMeals(by: category)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Meals Grid
    var mealGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(filteredMeals) { meal in
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    VStack(alignment: .leading, spacing: 6) {
                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 140)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(meal.strMeal)
                            .font(.headline)
                            .lineLimit(2)
                            .padding(.horizontal, 6)
                            .padding(.bottom, 8)
                    }
                    .background(Color(.systemBackground))
                    .foregroundStyle(Color(.black))
                    .cornerRadius(16)
                    .shadow(radius: 3)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MealListView()
}
