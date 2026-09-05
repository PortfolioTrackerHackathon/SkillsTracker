//
//  Facilitator.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 4/9/2026.
//

import SwiftUI
internal import Combine

// MARK: - DESIGN SYSTEM

// Brand palette used across the Facilitator sign up and dashboard screens.
// Indigo/blue = primary brand, orange = attention/alerts, green = success.
extension Color {
    static let facilitatorPrimary = Color.indigo
    static let facilitatorSecondary = Color.blue
    static let facilitatorAlert = Color.orange
    static let facilitatorSuccess = Color.green
}

// MARK: - MODELS

enum EvidenceStatus: String, CaseIterable, Identifiable {
    case pending = "Pending Review"
    case demonstrated = "Demonstrated"
    case needsImprovement = "Needs Improvement"

    var id: String {
        rawValue
    }
}

// MARK: Skill Evidence

struct SkillEvidence: Identifiable, Hashable {
    let id: UUID
    var studentId: UUID
    var skillName: String
    var evidenceType: String
    var attachmentLink: String
    var status: EvidenceStatus
    var facilitatorFeedback: String

    init(
        id: UUID = UUID(),
        studentId: UUID,
        skillName: String,
        evidenceType: String,
        attachmentLink: String,
        status: EvidenceStatus = .pending,
        facilitatorFeedback: String = ""
    ) {
        self.id = id
        self.studentId = studentId
        self.skillName = skillName
        self.evidenceType = evidenceType
        self.attachmentLink = attachmentLink
        self.status = status
        self.facilitatorFeedback = facilitatorFeedback
    }
}

// MARK: Student

struct Student: Identifiable, Hashable {
    let id: UUID
    var name: String
    var email: String
    var programLevel: String

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        programLevel: String
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.programLevel = programLevel
    }
}

// MARK: Facilitator

struct Facilitator: Identifiable, Hashable {
    let id: UUID
    var name: String
    var email: String

    init(
        id: UUID = UUID(),
        name: String,
        email: String
    ) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// MARK: Skill Category

enum SkillCategory: String, CaseIterable, Identifiable {
    case soft = "Soft Skill"
    case technical = "Technical Skill"

    var id: String {
        rawValue
    }
}

// MARK: Student Skill

struct Skill: Identifiable, Hashable {
    let id: UUID
    var studentId: UUID
    var name: String
    var category: SkillCategory

    init(
        id: UUID = UUID(),
        studentId: UUID,
        name: String,
        category: SkillCategory
    ) {
        self.id = id
        self.studentId = studentId
        self.name = name
        self.category = category
    }
}

// MARK: - DATA MANAGER

final class SchoolDataManager: ObservableObject {

    @Published var students: [Student] = []
    @Published var allEvidences: [SkillEvidence] = []
    @Published var recentActivity: String = ""

    // MARK: Facilitators

    @Published var facilitators: [Facilitator] = []
    @Published var currentFacilitator: Facilitator?

    // MARK: Student Skills

    @Published var studentSkills: [Skill] = []

    // MARK: Get Evidence For Student

    func evidence(for studentId: UUID) -> [SkillEvidence] {
        allEvidences.filter {
            $0.studentId == studentId
        }
    }

    // MARK: Verify Evidence

    func verifyEvidence(
        id: UUID,
        newStatus: EvidenceStatus,
        feedback: String
    ) {
        guard let index = allEvidences.firstIndex(
            where: { $0.id == id }
        ) else {
            return
        }

        allEvidences[index].status = newStatus
        allEvidences[index].facilitatorFeedback =
            feedback.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        recentActivity =
            "Evidence status was updated."
    }

    // MARK: Update Student

    func updateStudent(
        id: UUID,
        name: String,
        email: String,
        programLevel: String
    ) {
        guard let index = students.firstIndex(
            where: { $0.id == id }
        ) else {
            return
        }

        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanLevel = programLevel.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty,
              !cleanEmail.isEmpty,
              !cleanLevel.isEmpty else {
            return
        }

        students[index].name = cleanName
        students[index].email = cleanEmail
        students[index].programLevel = cleanLevel

        recentActivity =
            "\(cleanName)'s profile was updated."
    }

    // MARK: Find Student

    func student(with id: UUID) -> Student? {
        students.first {
            $0.id == id
        }
    }

    // MARK: Sign Up Facilitator

    func signUpFacilitator(
        name: String,
        email: String
    ) -> Bool {
        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty,
              cleanEmail.contains("@"),
              cleanEmail.contains(".") else {
            return false
        }

        let newFacilitator = Facilitator(
            name: cleanName,
            email: cleanEmail
        )

        facilitators.append(newFacilitator)
        currentFacilitator = newFacilitator

        recentActivity =
            "\(cleanName) signed up as a facilitator."

        return true
    }

    // MARK: Load Facilitator Demo Data

    func loadFacilitatorDemoData() {
        guard students.isEmpty else {
            return
        }

        let alex = Student(
            name: "Alex Johnson",
            email: "alex.johnson@example.com",
            programLevel: "Intermediate"
        )
        let maya = Student(
            name: "Maya Patel",
            email: "maya.patel@example.com",
            programLevel: "Beginner"
        )
        let sam = Student(
            name: "Sam Williams",
            email: "sam.williams@example.com",
            programLevel: "Advanced"
        )

        students = [alex, maya, sam]
        studentSkills = [
            Skill(studentId: alex.id, name: "Communication", category: .soft),
            Skill(studentId: alex.id, name: "SwiftUI", category: .technical),
            Skill(studentId: maya.id, name: "Teamwork", category: .soft),
            Skill(studentId: maya.id, name: "HTML & CSS", category: .technical),
            Skill(studentId: sam.id, name: "Leadership", category: .soft),
            Skill(studentId: sam.id, name: "Data Structures", category: .technical)
        ]
        allEvidences = [
            SkillEvidence(
                studentId: alex.id,
                skillName: "SwiftUI",
                evidenceType: "GitHub Project",
                attachmentLink: "github.com/alex/swiftui-portfolio",
                status: .pending
            ),
            SkillEvidence(
                studentId: maya.id,
                skillName: "Teamwork",
                evidenceType: "Video Reflection",
                attachmentLink: "portfolio.example.com/maya/teamwork",
                status: .demonstrated,
                facilitatorFeedback: "Clear reflection and strong examples."
            ),
            SkillEvidence(
                studentId: sam.id,
                skillName: "Leadership",
                evidenceType: "Assessment",
                attachmentLink: "portfolio.example.com/sam/leadership",
                status: .needsImprovement,
                facilitatorFeedback: "Add a specific example of delegation."
            )
        ]
        recentActivity = "Demo students and skill evidence are ready to review."
    }

    // MARK: Sign Out Facilitator

    func signOutFacilitator() {
        currentFacilitator = nil
    }

    // MARK: Get Skills For Student

    func skills(
        for studentId: UUID,
        category: SkillCategory
    ) -> [Skill] {
        studentSkills.filter {
            $0.studentId == studentId &&
            $0.category == category
        }
    }

    // MARK: Add Skill

    func addSkill(
        studentId: UUID,
        name: String,
        category: SkillCategory
    ) {
        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty else {
            return
        }

        studentSkills.append(
            Skill(
                studentId: studentId,
                name: cleanName,
                category: category
            )
        )

        recentActivity =
            "\(cleanName) (\(category.rawValue)) was added."
    }

    // MARK: Delete Skill

    func deleteSkill(id: UUID) {
        guard let skill = studentSkills.first(where: { $0.id == id }) else {
            return
        }

        studentSkills.removeAll {
            $0.id == id
        }

        recentActivity = "\(skill.name) was deleted."
    }
}

// MARK: - FACILITATOR SIGN UP

struct FacilitatorSignupView: View {

    @EnvironmentObject private var dataManager:
        SchoolDataManager

    @State private var name = ""
    @State private var email = ""
    @State private var signupError = ""
    @State private var showFacilitatorView = false

    // MARK: Validation

    private var canSignUp: Bool {

        !name.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty

        &&
        !email.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    // MARK: Body

    var body: some View {

        NavigationStack {

            ZStack {

                // Soft brand-tinted background wash
                LinearGradient(
                    colors: [
                        Color.facilitatorPrimary.opacity(0.16),
                        Color(.systemGroupedBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 28) {

                        // MARK: Header

                        VStack(spacing: 14) {

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
                                        width: 88,
                                        height: 88
                                    )
                                    .shadow(
                                        color:
                                            Color.facilitatorPrimary.opacity(0.35),
                                        radius: 12,
                                        y: 6
                                    )

                                Image(
                                    systemName:
                                        "person.badge.plus.fill"
                                )
                                .font(
                                    .system(size: 34)
                                )
                                .foregroundStyle(.white)
                            }

                            VStack(spacing: 6) {

                                Text("Facilitator Sign Up")
                                    .font(.title2)
                                    .bold()

                                Text(
                                    "Create an account to manage students and review their skills."
                                )
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                            }
                        }
                        .padding(.top, 44)

                        // MARK: Form Card

                        VStack(spacing: 18) {

                            SignupField(
                                icon: "person.fill",
                                placeholder: "Full Name",
                                text: $name,
                                isEmail: false
                            )

                            SignupField(
                                icon: "envelope.fill",
                                placeholder: "Email",
                                text: $email,
                                isEmail: true
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .fill(
                                Color(.secondarySystemGroupedBackground)
                            )
                            .shadow(
                                color: .black.opacity(0.06),
                                radius: 10,
                                y: 4
                            )
                        )
                        .padding(.horizontal)

                        // MARK: Sign Up Button

                        VStack(spacing: 10) {

                            Button {

                                let didSignUp = dataManager.signUpFacilitator(
                                    name: name,
                                    email: email
                                )

                                if !didSignUp {
                                    signupError = "Enter a full name and a valid email address."
                                } else {
                                    dataManager.loadFacilitatorDemoData()
                                    showFacilitatorView = true
                                }

                            } label: {

                                Text("Sign Up")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .background(
                                LinearGradient(
                                    colors:
                                        canSignUp
                                        ? [
                                            Color.facilitatorPrimary,
                                            Color.facilitatorSecondary
                                        ]
                                        : [
                                            Color.gray.opacity(0.4),
                                            Color.gray.opacity(0.4)
                                        ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16
                                )
                            )
                            .disabled(!canSignUp)

                            Text(
                                "No password needed — signing up instantly creates your facilitator profile."
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showFacilitatorView) {
                FacilitatorView()
            }
            .alert("Signup unsuccessful", isPresented: Binding(
                get: { !signupError.isEmpty },
                set: { isPresented in
                    if !isPresented {
                        signupError = ""
                    }
                }
            )) {
                Button("OK", role: .cancel) {
                    signupError = ""
                }
            } message: {
                Text(signupError)
            }
        }
    }
}

// MARK: - SIGNUP FIELD

struct SignupField: View {

    let icon: String
    let placeholder: String

    @Binding var text: String

    let isEmail: Bool

    var body: some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(Color.facilitatorPrimary)
                .frame(width: 20)

            TextField(
                placeholder,
                text: $text
            )
            .keyboardType(
                isEmail ? .emailAddress : .default
            )
            .textInputAutocapitalization(
                isEmail ? .never : .words
            )
            .autocorrectionDisabled(isEmail)
        }
        .padding(.vertical, 10)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.separator)),
            alignment: .bottom
        )
    }
}

// MARK: - FACILITATOR DASHBOARD

struct FacilitatorView: View {

    @EnvironmentObject private var dataManager:
        SchoolDataManager
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var showNotifications = false

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

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button(
                        "Sign Out",
                        role: .destructive
                    ) {

                        dataManager.signOutFacilitator()
                        dismiss()
                    }
                }

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {

                        showNotifications = true

                    } label: {

                        Image(
                            systemName: "bell.fill"
                        )
                        .foregroundStyle(Color.facilitatorAlert)
                    }
                    .accessibilityLabel(
                        "Notifications"
                    )
                }
            }
            .alert(
                "Notifications",
                isPresented: $showNotifications
            ) {

                Button(
                    "OK",
                    role: .cancel
                ) {}

            } message: {

                Text(
                    dataManager.recentActivity.isEmpty
                    ?
                    "You have no new notifications."
                    :
                    dataManager.recentActivity
                )
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
    @State private var skillPendingDeletion: Skill?

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

                        EvidenceRow(
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

                        EvidenceRow(
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

                        SkillRow(skill: skill) {
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

                        SkillRow(skill: skill) {
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
        _ skills: [Skill],
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

private struct SkillRow: View {

    let skill: Skill
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
                                category.rawValue
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

struct EvidenceRow: View {

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

#Preview("Facilitator Sign Up") {

    FacilitatorSignupView()
        .environmentObject(SchoolDataManager())
}
