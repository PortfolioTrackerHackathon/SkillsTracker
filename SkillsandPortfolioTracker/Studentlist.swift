//
//  Studentlist.swift
//  SkillsandPortfolioTracker
//
//  Created by Sebastian on 5/9/2026.
//

import SwiftUI

struct Studentlist: View {
    let teal = PortfolioTheme.teal
    let navy = PortfolioTheme.navy
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Students")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(navy)
                    
                    Text("Select a student to view their portfolio")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Student Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15)
                ], spacing: 15) {
                    ForEach(demoStudentNames, id: \.self) { name in
                        NavigationLink(destination: HomeView(userName: name)) {
                            StudentCard(name: name, teal: teal, navy: navy)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 30)
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Students")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentCard: View {
    let name: String
    let teal: Color
    let navy: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(navy)
                    .frame(width: 60, height: 60)
                
                Text(String(name.prefix(1)).uppercased())
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(teal)
            }
            
            // Name
            Text(name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(navy)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // View button
            HStack(spacing: 6) {
                Text("View Portfolio")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(teal)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(teal)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }
}

#Preview {
    NavigationStack {
        Studentlist()
    }
}

#Preview("Student Card") {
    StudentCard(name: "Sebastian", teal: PortfolioTheme.teal, navy: PortfolioTheme.navy)
        .padding()
        .background(Color(.systemBackground))
}
