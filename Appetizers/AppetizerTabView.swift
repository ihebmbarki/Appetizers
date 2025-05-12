//
//  ContentView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 21/4/2025.
//

import SwiftUI

struct AppetizerTabView: View {
    var body: some View {
        TabView {
            AppetizerListView()
                .tabItem {
                    Image(systemName:"house")
                    Text("Home")
                }
            AccountView()
                .tabItem {
                    Image(systemName:"person")
                    Text("account")
                }
            OrderView()
                .tabItem {
                    Image(systemName:"bag")
                    Text("Order")
                }
        }
        .accentColor(Color("brandPrimary"))
    }
}

#Preview {
    AppetizerTabView()
}
