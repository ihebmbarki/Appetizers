//
//  AppetizerListView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 21/4/2025.
//

import SwiftUI

struct AppetizerListView: View {
    
    @State private var viewModel = AppetizerListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.appetizers) { appetizer in
                AppetizerListCell(appetizer: appetizer)
            }
            .navigationTitle("🍟 Appetizers")
            .onAppear() {
                viewModel.getAppetizers()
            }
        }
        
    }
    
}

#Preview {
    AppetizerListView()
}
