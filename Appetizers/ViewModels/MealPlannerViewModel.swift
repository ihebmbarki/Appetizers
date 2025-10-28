//
//  MealPlannerViewModel.swift
//  Appetizers
//
//  Created by Iheb Mbarki on 14/10/2025.
//

import Foundation

@MainActor
final class MealPlannerViewModel: ObservableObject {
    @Published var weekPlan: [DayPlan] = []

    init() {
        weekPlan = [
            DayPlan(dayName: "Monday", slots: MealPlannerViewModel.defaultSlots()),
            DayPlan(dayName: "Tuesday", slots: MealPlannerViewModel.defaultSlots()),
            DayPlan(dayName: "Wednesday", slots: MealPlannerViewModel.defaultSlots()),
            DayPlan(dayName: "Thursday", slots: MealPlannerViewModel.defaultSlots()),
            DayPlan(dayName: "Friday", slots: MealPlannerViewModel.defaultSlots()),
            DayPlan(dayName: "Saturday", slots: MealPlannerViewModel.defaultSlots()),
            DayPlan(dayName: "Sunday", slots: MealPlannerViewModel.defaultSlots())
        ]
    }

    static func defaultSlots() -> [MealSlot] {
        return [
            MealSlot(meal: nil, type: .breakfast),
            MealSlot(meal: nil, type: .lunch),
            MealSlot(meal: nil, type: .dinner)
        ]
    }

    func assignMeal(_ meal: Meal, to slot: MealSlot, in day: DayPlan) {
        if let dayIndex = weekPlan.firstIndex(where: { $0.id == day.id }),
           let slotIndex = weekPlan[dayIndex].slots.firstIndex(where: { $0.id == slot.id }) {
            weekPlan[dayIndex].slots[slotIndex].meal = meal
        }
    }
}

