//
//  Admin.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 4/9/2026.
//

//
//  Admin.swift
//  Skills Portfolio Tracker
//
//  Admin "Manage Skills" screen.
//

import SwiftUI

// MARK: - Admin Screen

struct Admin: View {
    @EnvironmentObject private var dataManager: SchoolDataManager
    @State private var showingAddSkill = false
    @State private var editingSkill: Skill?
    @State private var showingManageUsers = false
    @State private var skillSearchText = ""
    @State private var deletedSkill: Skill?
    @State private var showDeletedToast = false
    @State private var selectedTab = "Skills"
    @State private var showEditProfile = false
    @State private var showSettings = false
    @State private var showNotifications = false

    var filteredSkills: [Skill] {
        if skillSearchText.isEmpty {
            return dataManager.catalogSkills
        }
        return dataManager.catalogSkills.filter { $0.name.localizedCaseInsensitiveContains(skillSearchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationStack {
                Group {
                    switch selectedTab {
                    case "Students":
                        adminStudentsTab
                    case "Insights":
                        adminInsightsTab
                    case "Profile":
                        adminProfileTab
                    default:
                        skillsList
                    }
                }
                .navigationTitle(selectedTab == "Skills" ? "Manage Skills" : selectedTab)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if selectedTab == "Profile" {
                            Button {
                                showEditProfile = true
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .accessibilityLabel("Edit profile")
                        }

                        Button {
                            showNotifications = true
                        } label: {
                            Image(systemName: dataManager.unreadNotificationCount > 0 ? "bell.badge" : "bell")
                        }
                        .accessibilityLabel("Notifications")

                        Button {
                            showingManageUsers = true
                        } label: {
                            Image(systemName: "person.3.fill")
                                .foregroundStyle(PortfolioTheme.teal)
                        }

                        if selectedTab == "Skills" {
                            Button {
                                showingAddSkill = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(PortfolioTheme.teal)
                            }
                        }
                    }
                }
            }

            BottomTabBar(selectedTab: $selectedTab)
        }
        .sheet(isPresented: $showingAddSkill) {
            SkillEditorView(mode: .add) { newSkill in
                dataManager.catalogSkills.append(newSkill)
            }
        }
        .sheet(item: $editingSkill) { skill in
            SkillEditorView(mode: .edit(skill)) { updatedSkill in
                if let index = dataManager.catalogSkills.firstIndex(where: { $0.id == updatedSkill.id }) {
                    dataManager.catalogSkills[index] = updatedSkill
                }
            } onDelete: {
                dataManager.catalogSkills.removeAll { $0.id == skill.id }
            }
        }
        .sheet(isPresented: $showingManageUsers) {
            ManageUsersView(
                students: $dataManager.students,
                facilitators: $dataManager.facilitators
            )
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
        .overlay(alignment: .bottom) {
            if showDeletedToast, let skill = deletedSkill {
                UndoToast(
                    message: "Deleted \(skill.name)",
                    onUndo: {
                        dataManager.catalogSkills.append(skill)
                        deletedSkill = nil
                        showDeletedToast = false
                    }
                )
                .padding(.bottom, 70)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    private var skillsList: some View {
        List {
            SearchBar(text: $skillSearchText, placeholder: "Search skills...")
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

            if filteredSkills.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Skills Found",
                    message: skillSearchText.isEmpty ? "No skills yet. Tap + to create one" : "No skills match your search"
                )
                .listRowSeparator(.hidden)
            } else {
                ForEach(SkillCategory.allCases) { category in
                    let categorySkills = filteredSkills.filter { $0.category == category }
                    if !categorySkills.isEmpty {
                        Section {
                            ForEach(categorySkills) { skill in
                                CatalogSkillRow(skill: skill)
                                    .contentShape(Rectangle())
                                    .onTapGesture { editingSkill = skill }
                            }
                            .onDelete { offsets in
                                deleteSkill(offsets, in: categorySkills)
                            }
                        } header: {
                            Text("\(category.rawValue) Skills")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(PortfolioTheme.subtitleGray)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var adminStudentsTab: some View {
        List(dataManager.students) { student in
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

    private var adminInsightsTab: some View {
        List {
            Section("Overview") {
                LabeledContent("Students", value: "\(dataManager.students.count)")
                LabeledContent("Facilitators", value: "\(dataManager.facilitators.count)")
                LabeledContent("Catalog skills", value: "\(dataManager.catalogSkills.count)")
                LabeledContent("Pending evidence", value: "\(dataManager.allEvidences.filter { $0.status == .pending }.count)")
            }
        }
    }

    private var adminProfileTab: some View {
        List {
            Section("Admin") {
                LabeledContent("Name", value: dataManager.currentUserName.isEmpty ? "Admin" : dataManager.currentUserName)
                LabeledContent("Email", value: dataManager.currentEmail.isEmpty ? "—" : dataManager.currentEmail)
                LabeledContent("Department", value: dataManager.currentDetail.isEmpty ? "MCRI Administration" : dataManager.currentDetail)
                LabeledContent("Role", value: "Admin")
            }

            Section("Account") {
                Button {
                    showEditProfile = true
                } label: {
                    Label("Edit Profile", systemImage: "pencil")
                }
                Button {
                    showNotifications = true
                } label: {
                    Label("Notifications", systemImage: "bell")
                }
                Button {
                    showSettings = true
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }

            Section {
                SignOutButton()
            }
        }
    }

    private func deleteSkill(_ offsets: IndexSet, in categorySkills: [Skill]) {
        if let index = offsets.first {
            let skill = categorySkills[index]
            deletedSkill = skill
            dataManager.catalogSkills.removeAll { $0.id == skill.id }
            showDeletedToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if deletedSkill?.id == skill.id {
                    showDeletedToast = false
                }
            }
        }
    }
}

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(PortfolioTheme.subtitleGray)

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: 16))

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(PortfolioTheme.subtitleGray)
                }
            }
        }
        .padding(12)
        .background(PortfolioTheme.cardBackground)
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(PortfolioTheme.teal.opacity(0.5))

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(PortfolioTheme.navy)

            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(PortfolioTheme.subtitleGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

// MARK: - Undo Toast

struct UndoToast: View {
    let message: String
    let onUndo: () -> Void

    var body: some View {
        HStack {
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)

            Spacer()

            Button("Undo") {
                onUndo()
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(PortfolioTheme.teal)
        }
        .padding(16)
        .background(PortfolioTheme.navy)
        .cornerRadius(12)
        .padding(16)
    }
}

// MARK: - Skill Row

struct CatalogSkillRow: View {
    let skill: Skill

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(skill.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(PortfolioTheme.navy)

                Spacer()

                Text("\(skill.demonstratedCount)/\(skill.totalStudents)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(PortfolioTheme.subtitleGray)
            }

            ProgressView(value: skill.progress)
                .tint(PortfolioTheme.teal)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Skill Editor

struct SkillEditorView: View {
    enum Mode {
        case add
        case edit(Skill)

        var title: String {
            switch self {
            case .add: return "New Skill"
            case .edit: return "Edit Skill"
            }
        }
    }

    let mode: Mode
    let onSave: (Skill) -> Void
    var onDelete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var category: SkillCategory
    @State private var demonstratedCount: Int
    @State private var totalStudents: Int

    private let existingID: UUID?

    init(mode: Mode, onSave: @escaping (Skill) -> Void, onDelete: (() -> Void)? = nil) {
        self.mode = mode
        self.onSave = onSave
        self.onDelete = onDelete

        switch mode {
        case .add:
            _name = State(initialValue: "")
            _category = State(initialValue: .technical)
            _demonstratedCount = State(initialValue: 0)
            _totalStudents = State(initialValue: 100)
            existingID = nil
        case .edit(let skill):
            _name = State(initialValue: skill.name)
            _category = State(initialValue: skill.category)
            _demonstratedCount = State(initialValue: skill.demonstratedCount)
            _totalStudents = State(initialValue: skill.totalStudents)
            existingID = skill.id
        }
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && totalStudents > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Skill") {
                    TextField("Skill name", text: $name)

                    Picker("Category", selection: $category) {
                        ForEach(SkillCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }

                Section("Demonstration tracking") {
                    Stepper(value: $totalStudents, in: 1...1000) {
                        HStack {
                            Text("Total students")
                            Spacer()
                            Text("\(totalStudents)")
                                .foregroundStyle(PortfolioTheme.subtitleGray)
                        }
                    }

                    Stepper(value: $demonstratedCount, in: 0...totalStudents) {
                        HStack {
                            Text("Demonstrated by")
                            Spacer()
                            Text("\(demonstratedCount)")
                                .foregroundStyle(PortfolioTheme.subtitleGray)
                        }
                    }
                }

                if let onDelete {
                    Section {
                        Button("Delete Skill", role: .destructive) {
                            onDelete()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let skill = Skill(
                            id: existingID ?? UUID(),
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            category: category,
                            demonstratedCount: demonstratedCount,
                            totalStudents: totalStudents
                        )
                        onSave(skill)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

// MARK: - Bottom Tab Bar

struct BottomTabBar: View {
    @Binding var selectedTab: String
    private let tabs = ["Skills", "Students", "Insights", "Profile"]

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Spacer()
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: 6) {
                            Text(tab)
                                .font(.system(size: 14, weight: tab == selectedTab ? .bold : .medium))
                                .foregroundStyle(tab == selectedTab ? PortfolioTheme.teal : PortfolioTheme.navy)

                            Rectangle()
                                .fill(tab == selectedTab ? PortfolioTheme.teal : .clear)
                                .frame(width: 28, height: 2)
                        }
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview

struct Admin_Previews: PreviewProvider {
    static var previews: some View {
        Admin()
            .environmentObject(SchoolDataManager())
    }
}
