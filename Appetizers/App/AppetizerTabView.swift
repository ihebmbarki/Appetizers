//
//  ContentView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 21/4/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MealListView()
                .tabItem {
                    Label("Explore", systemImage: "house.fill")
                }
            
            MealPlannerView()
                .tabItem {
                    Label("Planner", systemImage: "calendar.circle")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}


#Preview {
    MainTabView()
}
