//
//  RoleRootView.swift
//  SkillsandPortfolioTracker
//
//  Routes a logged-in session to the matching role view file.
//

import SwiftUI

struct RoleRootView: View {
    @EnvironmentObject private var dataManager: SchoolDataManager

    var body: some View {
        Group {
            switch dataManager.currentRole {
            case .student:
                HomeView(
                    userName: demoStudentNames[0]
                )
            case .facilitator:
                FacilitatorView()
            case .admin:
                AdminView()
            case .employer:
                EmployerView()
            case nil:
                LoginView()
            }
        }
        .background(Color(.systemBackground))
    }
}
