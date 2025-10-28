//
//  MealPlannerView.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import SwiftUI

struct MealPlannerView: View {
    @StateObject private var viewModel = MealPlannerViewModel()
    @State private var showingMealPicker = false
    @State private var selectedSlot: (day: DayPlan, slot: MealSlot)?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.weekPlan) { day in
                    Section(header: Text(day.dayName).font(.headline)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 12) {
                                ForEach(day.slots) { slot in
                                    slotCell(for: slot, in: day)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle("Meal Planner")
            .sheet(isPresented: $showingMealPicker) {
                if let selected = selectedSlot {
                    MealPickerView { meal in
                        viewModel.assignMeal(meal, to: selected.slot, in: selected.day)
                        showingMealPicker = false
                    }
                }
            }
        }
    }

    // MARK: - Slot Cell
    @ViewBuilder
    private func slotCell(for slot: MealSlot, in day: DayPlan) -> some View {
        if let meal = slot.meal {
            NavigationLink(destination: MealDetailView(meal: meal)) {
                MealListCell(meal: meal)
                    .frame(width: 120, height: 150)
            }
        } else {
            Button(action: {
                selectedSlot = (day, slot)
                showingMealPicker = true
            }) {
                VStack {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    Text(slot.type.rawValue.capitalized)
                        .font(.subheadline)
                }
                .frame(width: 120, height: 150)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }
        }
    }
}
