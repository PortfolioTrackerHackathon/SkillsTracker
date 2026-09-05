//
//  SkillsandPortfolioTrackerApp.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 4/9/2026.
//

import SwiftUI

@main
struct SkillsandPortfolioTrackerApp: App {
    @StateObject private var dataManager = SchoolDataManager()

    var body: some Scene {
        WindowGroup {
            RootSwitcherView()
                .environmentObject(dataManager)
                .preferredColorScheme(dataManager.appearance.colorScheme)
                .dynamicTypeSize(dataManager.textSize.dynamicTypeSize)
        }
    }
}

struct RootSwitcherView: View {
    @EnvironmentObject private var dataManager: SchoolDataManager

    var body: some View {
        Group {
            if let role = dataManager.currentRole {
                RoleRootView()
                    .id(role)
                    .transition(.opacity)
            } else {
                ContentView()
                    .id("logged-out")
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: dataManager.currentRole)
    }
}
