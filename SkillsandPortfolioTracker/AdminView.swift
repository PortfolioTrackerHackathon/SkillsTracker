//
//  AdminView.swift
//  SkillsandPortfolioTracker
//
//  Admin portal opened after a successful admin login.
//

import SwiftUI

struct AdminView: View {
    var body: some View {
        Admin()
    }
}

#Preview {
    AdminView()
        .environmentObject(SchoolDataManager())
}
