//
//  Facilitator.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 4/9/2026.
//

import SwiftUI

extension Color {
    static let facilitatorPrimary = Color.indigo
    static let facilitatorSecondary = Color.blue
    static let facilitatorAlert = Color.orange
    static let facilitatorSuccess = Color.green
}

// MARK: - FACILITATOR DASHBOARD

struct FacilitatorView: View {

    @EnvironmentObject private var dataManager:
        SchoolDataManager

    @State private var searchText = ""
    @State private var showNotifications = false
    @State private var showSettings = false
    @State private var showEditProfile = false

    // MARK: Filter Students

    private var filteredStudents: [Student] {

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            return dataManager.students
        }

        return dataManager.students.filter { student in

            student.name.localizedCaseInsensitiveContains(
                query
            )
            ||
            student.email.localizedCaseInsensitiveContains(
                query
            )
            ||
            student.programLevel.localizedCaseInsensitiveContains(
                query
            )
        }
    }

    // MARK: Pending Review Count

    private var pendingReviewCount: Int {
        dataManager.allEvidences.filter {
            $0.status == .pending
        }.count
    }

    // MARK: Facilitator Initials

    private var facilitatorInitials: String {

        let name =
            dataManager.currentFacilitator?.name ?? "F"

        let letters =
            name.split(separator: " ")
                .prefix(2)
                .compactMap { $0.first }

        return letters.isEmpty
            ? "F"
            : String(letters).uppercased()
    }

    // MARK: Body

    var body: some View {

        NavigationStack {

            List {

                // MARK: Greeting

                Section {

                    HStack(spacing: 16) {

                        ZStack {

                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.facilitatorPrimary,
                                            Color.facilitatorSecondary
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(
                                    width: 56,
                                    height: 56
                                )

                            Text(facilitatorInitials)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }

                        VStack(
                            alignment: .leading,
                            spacing: 2
                        ) {

                            Text(
                                "Hello, \(dataManager.currentFacilitator?.name ?? "Facilitator")"
                            )
                            .font(.title3)
                            .bold()

                            Text("Facilitator Portal")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                // MARK: Quick Stats

                Section {

                    HStack(spacing: 12) {

                        StatCard(
                            title: "Students",
                            value:
                                "\(dataManager.students.count)",
                            icon: "person.3.fill",
                            tint: Color.facilitatorSecondary
                        )

                        StatCard(
                            title: "Pending",
                            value:
                                "\(pendingReviewCount)",
                            icon:
                                "clock.badge.exclamationmark.fill",
                            tint: Color.facilitatorAlert
                        )
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

                // MARK: Global Alerts

                Section("Global Alerts") {

                    if dataManager.recentActivity.isEmpty {

                        Label(
                            "No new notifications",
                            systemImage: "bell.slash"
                        )
                        .foregroundStyle(.secondary)

                    } else {

                        Label(
                            dataManager.recentActivity,
                            systemImage: "bell.badge"
                        )
                        .font(.subheadline)
                        .foregroundStyle(Color.facilitatorAlert)
                        .bold()
                    }
                }

                // MARK: Student Roster

                Section("Student Roster") {

                    if filteredStudents.isEmpty {

                        EmptyStudentSearchView(
                            searchText: searchText
                        )

                    } else {

                        ForEach(filteredStudents) { student in

                            NavigationLink {

                                StudentFullProfileView(
                                    studentID: student.id
                                )

                            } label: {

                                StudentRow(
                                    student: student
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Facilitator Portal")
            .searchable(
                text: $searchText,
                prompt: "Search students..."
            )
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
        }
    }
}

// MARK: - STAT CARD

struct StatCard: View {

    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(tint)

            Text(value)
                .font(.title2)
                .bold()

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(tint.opacity(0.12))
        )
    }
}

// MARK: - STUDENT ROW

struct StudentRow: View {

    let student: Student

    var body: some View {

        HStack(spacing: 12) {

            Image(
                systemName: "person.circle.fill"
            )
            .resizable()
            .frame(
                width: 40,
                height: 40
            )
            .foregroundStyle(Color.facilitatorSecondary)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(student.name)
                    .font(.headline)

                Text(student.email)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(student.programLevel)
                    .font(.caption)
                    .foregroundStyle(Color.facilitatorSecondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - EMPTY SEARCH VIEW

struct EmptyStudentSearchView: View {

    let searchText: String

    var body: some View {

        VStack(spacing: 12) {

            Image(
                systemName:
                    "person.crop.circle.badge.xmark"
            )
            .font(.system(size: 45))
            .foregroundStyle(.red)

            Text("Student Not Found")
                .font(.headline)

            if searchText.isEmpty {

                Text("There are no students available.")

            } else {

                Text(
                    "No student matches \"\(searchText)\"."
                )
            }
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, 25)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
    }
}

// MARK: - STUDENT PROFILE

struct StudentFullProfileView: View {

    let studentID: UUID

    @EnvironmentObject private var dataManager:
        SchoolDataManager

    @State private var selectedEvidence:
        SkillEvidence?

    @State private var showEditStudent = false
    @State private var showAddSkill = false
    @State private var skillPendingDeletion: StudentSkill?

    private var student: Student? {

        dataManager.student(
            with: studentID
        )
    }

    var body: some View {

        Group {

            if let student {

                studentProfileView(
                    student: student
                )

            } else {

                ContentUnavailableView(
                    "Student Not Found",
                    systemImage:
                        "person.crop.circle.badge.xmark",
                    description:
                        Text(
                            "This student is no longer in the system."
                        )
                )
            }
        }
        .navigationTitle("Student Review")
        .toolbar {

            if student != nil {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {

                        showAddSkill = true

                    } label: {

                        Label(
                            "Add Skill",
                            systemImage: "plus"
                        )
                    }
                }

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {

                        showEditStudent = true

                    } label: {

                        Label(
                            "Edit",
                            systemImage: "pencil"
                        )
                    }
                }
            }
        }
        .sheet(
            isPresented: $showEditStudent
        ) {

            if let student {

                EditStudentSheet(
                    student: student
                )
                .environmentObject(
                    dataManager
                )
            }
        }
        .sheet(
            isPresented: $showAddSkill
        ) {

            AddSkillSheet(
                studentId: studentID
            )
            .environmentObject(
                dataManager
            )
        }
        .sheet(
            item: $selectedEvidence
        ) { evidence in

            ReviewSheet(
                item: evidence
            )
            .environmentObject(
                dataManager
            )
        }
    }

    // MARK: Student Profile

    @ViewBuilder
    private func studentProfileView(
        student: Student
    ) -> some View {

        let studentEvidence =
            dataManager.evidence(
                for: student.id
            )

        let total =
            studentEvidence.count

        let demonstrated =
            studentEvidence.filter {
                $0.status == .demonstrated
            }.count

        let progress =
            Double(demonstrated) /
            Double(max(1, total))

        let pending =
            studentEvidence.filter {
                $0.status == .pending
            }

        let needsImprovement =
            studentEvidence.filter {
                $0.status == .needsImprovement
            }

        let verified =
            studentEvidence.filter {
                $0.status == .demonstrated
            }

        List {

            // MARK: Candidate Profile

            Section("Candidate Profile") {

                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text(student.name)
                        .font(.title)
                        .bold()

                    Label(
                        student.email,
                        systemImage: "envelope"
                    )
                    .font(.subheadline)

                    Label(
                        student.programLevel,
                        systemImage: "graduationcap"
                    )
                    .font(.subheadline)

                    Divider()

                    HStack {

                        Text(
                            "Progress"
                        )
                        .bold()

                        Spacer()

                        Text(
                            "\(demonstrated)/\(total)"
                        )
                        .bold()

                        Text(
                            "(\(Int(progress * 100))%)"
                        )
                        .foregroundStyle(
                            .secondary
                        )
                    }

                    ProgressView(
                        value: progress
                    )
                    .tint(.green)
                }
                .padding(.vertical, 8)
            }

            // MARK: Pending Evidence

            Section(
                "Pending Review (Action Required)"
            ) {

                if pending.isEmpty {

                    Label(
                        "All evidence reviewed!",
                        systemImage:
                            "checkmark.circle.fill"
                    )
                    .foregroundStyle(.green)

                } else {

                    ForEach(pending) { item in

                        FacilitatorEvidenceRow(
                            item: item
                        ) {

                            selectedEvidence = item
                        }
                    }
                }
            }

            // MARK: Needs Improvement

            Section("Needs Improvement") {

                if needsImprovement.isEmpty {

                    Text(
                        "No evidence requires improvement."
                    )
                    .foregroundStyle(.secondary)

                } else {

                    ForEach(
                        needsImprovement
                    ) { item in

                        FacilitatorEvidenceRow(
                            item: item
                        ) {

                            selectedEvidence = item
                        }
                    }
                }
            }

            // MARK: Verified Portfolio

            Section("Verified Portfolio") {

                if verified.isEmpty {

                    Text(
                        "No demonstrated skills yet."
                    )
                    .foregroundStyle(.secondary)

                } else {

                    ForEach(verified) { item in

                        VerifiedEvidenceRow(
                            item: item
                        )
                    }
                }
            }

            // MARK: Soft Skills

            let softSkills =
                dataManager.skills(
                    for: student.id,
                    category: .soft
                )

            Section("Soft Skills") {

                if softSkills.isEmpty {

                    Text(
                        "No soft skills added yet."
                    )
                    .foregroundStyle(.secondary)

                } else {

                    ForEach(softSkills) { skill in

                        FacilitatorSkillRow(skill: skill) {
                            skillPendingDeletion = skill
                        }
                    }
                    .onDelete { offsets in

                        deleteSkills(
                            softSkills,
                            at: offsets
                        )
                    }
                }
            }

            // MARK: Technical Skills

            let technicalSkills =
                dataManager.skills(
                    for: student.id,
                    category: .technical
                )

            Section("Technical Skills") {

                if technicalSkills.isEmpty {

                    Text(
                        "No technical skills added yet."
                    )
                    .foregroundStyle(.secondary)

                } else {

                    ForEach(technicalSkills) { skill in

                        FacilitatorSkillRow(skill: skill) {
                            skillPendingDeletion = skill
                        }
                    }
                    .onDelete { offsets in

                        deleteSkills(
                            technicalSkills,
                            at: offsets
                        )
                    }
                }
            }
        }
        .alert(
            "Delete Skill?",
            isPresented: Binding(
                get: { skillPendingDeletion != nil },
                set: { isPresented in
                    if !isPresented {
                        skillPendingDeletion = nil
                    }
                }
            ),
            presenting: skillPendingDeletion
        ) { skill in
            Button("Delete", role: .destructive) {
                dataManager.deleteSkill(id: skill.id)
                skillPendingDeletion = nil
            }
            Button("Cancel", role: .cancel) {
                skillPendingDeletion = nil
            }
        } message: { skill in
            Text("Remove \"\(skill.name)\" from this student's skills?")
        }
    }

    // MARK: Delete Skills

    private func deleteSkills(
        _ skills: [StudentSkill],
        at offsets: IndexSet
    ) {

        for index in offsets {

            dataManager.deleteSkill(
                id: skills[index].id
            )
        }
    }
}

// MARK: - SKILL ROW

private struct FacilitatorSkillRow: View {

    let skill: StudentSkill
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text(skill.name)

            Spacer()

            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Delete \(skill.name)")
        }
    }
}

// MARK: - ADD SKILL SHEET

struct AddSkillSheet: View {

    let studentId: UUID

    @EnvironmentObject private var dataManager:
        SchoolDataManager

    @Environment(\.dismiss)
    private var dismiss

    @State private var name = ""
    @State private var category:
        SkillCategory = .technical

    // MARK: Validation

    private var canSave: Bool {

        !name.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    // MARK: Body

    var body: some View {

        NavigationStack {

            Form {

                Section(
                    "Skill Details"
                ) {

                    TextField(
                        "Skill Name",
                        text: $name
                    )

                    Picker(
                        "Category",
                        selection: $category
                    ) {

                        ForEach(
                            SkillCategory.allCases
                        ) { category in

                            Text(
                                category.facilitatorLabel
                            )
                            .tag(category)
                        }
                    }
                }

                Section {

                    Button(
                        "Add Skill"
                    ) {

                        dataManager.addSkill(
                            studentId: studentId,
                            name: name,
                            category: category
                        )

                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .navigationTitle(
                "Add Skill"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button("Cancel") {

                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - EDIT STUDENT SHEET

struct EditStudentSheet: View {

    let student: Student

    @EnvironmentObject private var dataManager:
        SchoolDataManager

    @Environment(\.dismiss)
    private var dismiss

    @State private var name: String
    @State private var email: String
    @State private var programLevel: String

    init(student: Student) {

        self.student = student

        _name = State(
            initialValue: student.name
        )

        _email = State(
            initialValue: student.email
        )

        _programLevel = State(
            initialValue: student.programLevel
        )
    }

    // MARK: Validation

    private var canSave: Bool {

        !name.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty

        &&
        !email.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty

        &&
        !programLevel.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    // MARK: Body

    var body: some View {

        NavigationStack {

            Form {

                Section(
                    "Student Information"
                ) {

                    TextField(
                        "Name",
                        text: $name
                    )

                    TextField(
                        "Email",
                        text: $email
                    )
                    .keyboardType(
                        .emailAddress
                    )
                    .textInputAutocapitalization(
                        .never
                    )
                    .autocorrectionDisabled()

                    TextField(
                        "Program Level",
                        text: $programLevel
                    )
                }

                Section {

                    Button(
                        "Save Changes"
                    ) {

                        dataManager.updateStudent(
                            id: student.id,
                            name: name,
                            email: email,
                            programLevel:
                                programLevel
                        )

                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .navigationTitle(
                "Edit Student"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button("Cancel") {

                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - EVIDENCE ROW

struct FacilitatorEvidenceRow: View {

    let item: SkillEvidence

    let onReview: () -> Void

    var body: some View {

        HStack(spacing: 12) {

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(item.skillName)
                    .font(.headline)

                Text(
                    item.evidenceType
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )

                Text(
                    item.attachmentLink
                )
                .font(.caption)
                .foregroundStyle(.blue)
                .lineLimit(2)
            }

            Spacer()

            Button(
                "Review",
                action: onReview
            )
            .buttonStyle(
                .bordered
            )
            .controlSize(
                .small
            )
        }
        .padding(.vertical, 4)
    }
}

// MARK: - VERIFIED EVIDENCE ROW

struct VerifiedEvidenceRow: View {

    let item: SkillEvidence

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            HStack {

                Text(item.skillName)
                    .font(.headline)

                Spacer()

                Image(
                    systemName:
                        "checkmark.seal.fill"
                )
                .foregroundStyle(.green)
            }

            Text(
                "Evidence: \(item.evidenceType)"
            )
            .font(.caption)

            if !item.facilitatorFeedback.isEmpty {

                Text(
                    "Feedback: " +
                    item.facilitatorFeedback
                )
                .font(.caption)
                .italic()
                .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - REVIEW SHEET

struct ReviewSheet: View {

    let item: SkillEvidence

    @EnvironmentObject private var dataManager:
        SchoolDataManager

    @Environment(\.dismiss)
    private var dismiss

    @State private var feedback: String
    @State private var status: EvidenceStatus

    init(item: SkillEvidence) {

        self.item = item

        _feedback = State(
            initialValue:
                item.facilitatorFeedback
        )

        _status = State(
            initialValue:
                item.status
        )
    }

    // MARK: Body

    var body: some View {

        NavigationStack {

            Form {

                // MARK: Evidence Information

                Section(
                    "Evidence Information"
                ) {

                    LabeledContent(
                        "Skill",
                        value: item.skillName
                    )

                    LabeledContent(
                        "Evidence Type",
                        value: item.evidenceType
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 6
                    ) {

                        Text("Attachment")
                            .font(.caption)
                            .foregroundStyle(
                                .secondary
                            )

                        Text(
                            item.attachmentLink
                        )
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .textSelection(
                            .enabled
                        )
                    }
                }

                // MARK: Decision

                Section("Decision") {

                    Picker(
                        "Verdict",
                        selection: $status
                    ) {

                        ForEach(
                            EvidenceStatus.allCases
                        ) { status in

                            Text(
                                status.rawValue
                            )
                            .tag(status)
                        }
                    }
                    .pickerStyle(
                        .menu
                    )
                }

                // MARK: Feedback

                Section(
                    "Facilitator Feedback"
                ) {

                    TextEditor(
                        text: $feedback
                    )
                    .frame(
                        minHeight: 120
                    )
                }

                // MARK: Submit

                Section {

                    Button {

                        dataManager.verifyEvidence(
                            id: item.id,
                            newStatus: status,
                            feedback: feedback
                        )

                        dismiss()

                    } label: {

                        Label(
                            "Submit Decision",
                            systemImage:
                                "checkmark.circle.fill"
                        )
                        .frame(
                            maxWidth: .infinity
                        )
                    }
                    .buttonStyle(
                        .borderedProminent
                    )
                }
            }
            .navigationTitle(
                "Review Evidence"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Done") {

                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview("Facilitator Portal") {
    FacilitatorView()
        .environmentObject(SchoolDataManager())
}
