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

// MARK: - Models

enum SkillCategory: String, CaseIterable, Identifiable, Hashable {
    case technical = "Technical"
    case soft = "Soft"

    var id: String { rawValue }
}

struct Skill: Identifiable, Hashable {
    let id: UUID
    var name: String
    var category: SkillCategory
    var demonstratedCount: Int
    var totalStudents: Int

    init(
        id: UUID = UUID(),
        name: String,
        category: SkillCategory,
        demonstratedCount: Int,
        totalStudents: Int
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.demonstratedCount = demonstratedCount
        self.totalStudents = totalStudents
    }

    var progress: Double {
        guard totalStudents > 0 else { return 0 }
        return min(Double(demonstratedCount) / Double(totalStudents), 1)
    }
}

struct Student: Identifiable, Hashable {
    let id: UUID
    var name: String
    var email: String

    init(id: UUID = UUID(), name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

struct Facilitator: Identifiable, Hashable {
    let id: UUID
    var name: String
    var email: String

    init(id: UUID = UUID(), name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// MARK: - Sample Data

extension Skill {
    static let sample: [Skill] = [
        Skill(name: "Communication", category: .soft, demonstratedCount: 50, totalStudents: 100),
        Skill(name: "Algorithms", category: .technical, demonstratedCount: 10, totalStudents: 100),
        Skill(name: "Git", category: .technical, demonstratedCount: 62, totalStudents: 100),
        Skill(name: "Jira / Confluence", category: .technical, demonstratedCount: 34, totalStudents: 100),
        Skill(name: "Swift", category: .technical, demonstratedCount: 18, totalStudents: 100),
        Skill(name: "Curiosity", category: .soft, demonstratedCount: 71, totalStudents: 100),
        Skill(name: "Integrity", category: .soft, demonstratedCount: 88, totalStudents: 100),
        Skill(name: "Desire to Learn", category: .soft, demonstratedCount: 65, totalStudents: 100),
        Skill(name: "Willingness to Listen", category: .soft, demonstratedCount: 40, totalStudents: 100),
        Skill(name: "Empathy", category: .soft, demonstratedCount: 55, totalStudents: 100)
    ]
}

extension Student {
    static let sample: [Student] = [
        Student(name: "Tendai Moyo", email: "tendai@mcri.edu"),
        Student(name: "Rudo Ncube", email: "rudo@mcri.edu"),
        Student(name: "Brian Dube", email: "brian@mcri.edu"),
        Student(name: "Chipo Mwale", email: "chipo@mcri.edu"),
        Student(name: "Tapiwa Nyandoro", email: "tapiwa@mcri.edu")
    ]
}

extension Facilitator {
    static let sample: [Facilitator] = [
        Facilitator(name: "Sarah Johnson", email: "sarah@mcri.edu"),
        Facilitator(name: "James Williams", email: "james@mcri.edu"),
        Facilitator(name: "Emma Martinez", email: "emma@mcri.edu")
    ]
}

// MARK: - Theme

enum PortfolioTheme {
    static let navy = Color(red: 0.05, green: 0.11, blue: 0.24)
    static let teal = Color(red: 0.28, green: 0.72, blue: 0.65)
    static let tealTagBackground = Color(red: 0.28, green: 0.72, blue: 0.65).opacity(0.15)
    static let tealTagText = Color(red: 0.16, green: 0.50, blue: 0.45)
    static let tanTagBackground = Color(red: 0.97, green: 0.89, blue: 0.72)
    static let tanTagText = Color(red: 0.60, green: 0.42, blue: 0.13)
    static let cardBackground = Color(red: 0.97, green: 0.97, blue: 0.98)
    static let subtitleGray = Color(red: 0.45, green: 0.45, blue: 0.48)
    static let red = Color.red
}

// MARK: - Admin Screen

struct Admin: View {
    @State private var skills: [Skill] = Skill.sample
    @State private var students: [Student] = Student.sample
    @State private var facilitators: [Facilitator] = Facilitator.sample
    @State private var showingAddSkill = false
    @State private var editingSkill: Skill?
    @State private var showingManageUsers = false
    @State private var skillSearchText = ""
    
    @State private var deletedSkill: Skill?
    @State private var showDeletedToast = false

    var filteredSkills: [Skill] {
        if skillSearchText.isEmpty {
            return skills
        }
        return skills.filter { $0.name.localizedCaseInsensitiveContains(skillSearchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationStack {
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
                                        SkillRow(skill: skill)
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
                .navigationTitle("Manage Skills")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            showingManageUsers = true
                        } label: {
                            Image(systemName: "person.3.fill")
                                .foregroundStyle(PortfolioTheme.teal)
                        }

                        Button {
                            showingAddSkill = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(PortfolioTheme.teal)
                        }
                    }
                }
            }

            BottomTabBar(selectedTab: "Skills")
        }
        .sheet(isPresented: $showingAddSkill) {
            SkillEditorView(mode: .add) { newSkill in
                skills.append(newSkill)
            }
        }
        .sheet(item: $editingSkill) { skill in
            SkillEditorView(mode: .edit(skill)) { updatedSkill in
                if let index = skills.firstIndex(where: { $0.id == updatedSkill.id }) {
                    skills[index] = updatedSkill
                }
            } onDelete: {
                skills.removeAll { $0.id == skill.id }
            }
        }
        .sheet(isPresented: $showingManageUsers) {
            ManageUsersView(
                students: $students,
                facilitators: $facilitators
            )
        }
        .overlay(alignment: .bottom) {
            if showDeletedToast, let skill = deletedSkill {
                UndoToast(
                    message: "Deleted \(skill.name)",
                    onUndo: {
                        skills.append(skill)
                        deletedSkill = nil
                        showDeletedToast = false
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    private func deleteSkill(_ offsets: IndexSet, in categorySkills: [Skill]) {
        if let index = offsets.first {
            let skill = categorySkills[index]
            deletedSkill = skill
            skills.removeAll { $0.id == skill.id }
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

struct SkillRow: View {
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
    let selectedTab: String
    private let tabs = ["Skills", "Students", "Insights", "Profile"]

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Spacer()
                    VStack(spacing: 6) {
                        Text(tab)
                            .font(.system(size: 14, weight: tab == selectedTab ? .bold : .medium))
                            .foregroundStyle(tab == selectedTab ? PortfolioTheme.teal : PortfolioTheme.navy)

                        Rectangle()
                            .fill(tab == selectedTab ? PortfolioTheme.teal : .clear)
                            .frame(width: 28, height: 2)
                    }
                    Spacer()
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color.white)
    }
}

// MARK: - Preview

struct Admin_Previews: PreviewProvider {
    static var previews: some View {
        Admin()
    }
}
