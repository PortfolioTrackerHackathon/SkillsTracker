//
//  EmployerView.swift
//  SkillsandPortfolioTracker
//
//  Employer portal opened after a successful employer login.
//

import SwiftUI

struct EmployerView: View {
    @EnvironmentObject private var dataManager: SchoolDataManager

    var body: some View {
        EmployerDashboard(userName: dataManager.currentUserName.isEmpty ? "Employer" : dataManager.currentUserName)
    }
}

#Preview {
    EmployerView()
        .environmentObject(SchoolDataManager())
}
