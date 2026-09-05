//
//  Employer.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 4/9/2026.
//

import SwiftUI

struct EmployerDashboard: View {
    @EnvironmentObject private var dataManager: SchoolDataManager

    let userName: String
    @State private var searchText = ""
    @State private var showEditProfile = false
    @State private var showSettings = false
    @State private var showNotifications = false

    private var filteredStudents: [Student] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return dataManager.students }
        return dataManager.students.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.email.localizedCaseInsensitiveContains(query) ||
            $0.programLevel.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome, \(userName)")
                            .font(.title2.bold())
                        Text("Review student portfolios and verified skills.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Students") {
                    if filteredStudents.isEmpty {
                        Text("No students match your search.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(filteredStudents) { student in
                            NavigationLink {
                                EmployerStudentDetail(student: student)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(student.name)
                                        .font(.headline)
                                    Text(student.email)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    if !student.programLevel.isEmpty {
                                        Text(student.programLevel)
                                            .font(.caption)
                                            .foregroundStyle(PortfolioTheme.teal)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Employer Portal")
            .searchable(text: $searchText, prompt: "Search students")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    SignOutButton()
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showEditProfile = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .accessibilityLabel("Edit profile")

                    Button {
                        showNotifications = true
                    } label: {
                        Image(systemName: dataManager.unreadNotificationCount > 0 ? "bell.badge" : "bell")
                    }
                    .accessibilityLabel("Notifications")

                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack { SettingsView() }
            }
            .sheet(isPresented: $showNotifications) {
                NavigationStack { NotificationsView() }
            }
            .onAppear {
                dataManager.loadFacilitatorDemoData()
            }
        }
    }
}

struct EmployerStudentDetail: View {
    @EnvironmentObject private var dataManager: SchoolDataManager
    let student: Student

    private var evidence: [SkillEvidence] {
        dataManager.evidence(for: student.id)
    }

    private var demonstrated: [SkillEvidence] {
        evidence.filter { $0.status == .demonstrated }
    }

    private var skills: [StudentSkill] {
        dataManager.studentSkills.filter { $0.studentId == student.id }
    }

    var body: some View {
        List {
            Section("Candidate") {
                LabeledContent("Name", value: student.name)
                LabeledContent("Email", value: student.email)
                if !student.programLevel.isEmpty {
                    LabeledContent("Level", value: student.programLevel)
                }
            }

            Section("Skills") {
                if skills.isEmpty {
                    Text("No skills listed yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(skills) { skill in
                        LabeledContent(skill.name, value: skill.category.rawValue)
                    }
                }
            }

            Section("Verified evidence") {
                if demonstrated.isEmpty {
                    Text("No demonstrated evidence yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(demonstrated) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.skillName)
                                .font(.headline)
                            Text(item.evidenceType)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if !item.facilitatorFeedback.isEmpty {
                                Text(item.facilitatorFeedback)
                                    .font(.caption)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Portfolio")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Employer: View {
    var body: some View {
        EmployerDashboard(userName: "Employer")
    }
}

#Preview {
    EmployerDashboard(userName: "Alex")
        .environmentObject(SchoolDataManager())
}
