//
//  Models.swift
//  SkillsandPortfolioTracker
//
//  Shared models, theme, and app data for the Skills Portfolio Tracker
//



import Foundation
import SwiftUI
import Combine

// MARK: - Shared Theme

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

enum UserRole: String, CaseIterable, Identifiable {
    case student = "Student"
    case facilitator = "Facilitator"
    case admin = "Admin"
    case employer = "Employer"

    var id: String { rawValue }

    var portalTitle: String {
        "\(rawValue) Portal"
    }
}

enum AppearanceSetting: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum TextSizeSetting: Int, CaseIterable, Identifiable {
    case small = 0
    case medium = 1
    case large = 2
    case extraLarge = 3

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Default"
        case .large: return "Large"
        case .extraLarge: return "Extra Large"
        }
    }

    var dynamicTypeSize: DynamicTypeSize {
        switch self {
        case .small: return .small
        case .medium: return .large
        case .large: return .xxxLarge
        case .extraLarge: return .accessibility2
        }
    }
}

struct AppNotification: Identifiable, Hashable {
    let id: UUID
    var title: String
    var message: String
    var date: Date
    var isRead: Bool

    init(
        id: UUID = UUID(),
        title: String,
        message: String,
        date: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.isRead = isRead
    }
}

struct RoleAccount: Identifiable, Hashable {
    var id: String { username }
    let username: String
    let password: String
    let displayName: String
    let email: String
    let role: UserRole

    static let directory: [RoleAccount] = [
        RoleAccount(
            username: "facilitator",
            password: "facilitator123",
            displayName: "Peggy Mkoma",
            email: "peggy@mcri.edu",
            role: .facilitator
        ),
        RoleAccount(
            username: "admin",
            password: "admin123",
            displayName: "MCRI Admin",
            email: "admin@mcri.edu",
            role: .admin
        ),
        RoleAccount(
            username: "employer",
            password: "employer123",
            displayName: "Lennon Mudenda",
            email: "lennonmudenda@mcri.edu",
            role: .employer
        )
    ]

    static func account(for role: UserRole) -> RoleAccount? {
        directory.first { $0.role == role }
    }
}

// MARK: - Catalog / Admin Skills

enum SkillCategory: String, CaseIterable, Identifiable, Hashable {
    case technical = "Technical"
    case soft = "Soft"

    var id: String { rawValue }

    var facilitatorLabel: String {
        switch self {
        case .technical: return "Technical Skill"
        case .soft: return "Soft Skill"
        }
    }
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

// MARK: - People

struct Student: Identifiable, Hashable {
    let id: UUID
    var name: String
    var email: String
    var programLevel: String

    init(id: UUID = UUID(), name: String, email: String, programLevel: String = "") {
        self.id = id
        self.name = name
        self.email = email
        self.programLevel = programLevel
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

// MARK: - Evidence

enum EvidenceStatus: String, CaseIterable, Identifiable {
    case pending = "Pending Review"
    case demonstrated = "Demonstrated"
    case needsImprovement = "Needs Improvement"

    var id: String { rawValue }
}

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

struct EvidenceItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var type: String
    var fileData: Data?

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        type: String,
        fileData: Data? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.fileData = fileData
    }
}

// MARK: - Student portfolio skills (student dashboard)

struct PortfolioSkill: Identifiable, Hashable {
    let id: UUID
    var title: String
    var icon: String
    var status: String
    var category: String

    init(
        id: UUID = UUID(),
        title: String,
        icon: String,
        status: String,
        category: String
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.status = status
        self.category = category
    }
}

// MARK: - Facilitator-managed skills on a student record

struct StudentSkill: Identifiable, Hashable {
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
        Student(name: "Tendai Moyo", email: "tendai@mcri.edu", programLevel: "Intermediate"),
        Student(name: "Rudo Ncube", email: "rudo@mcri.edu", programLevel: "Beginner"),
        Student(name: "Brian Dube", email: "brian@mcri.edu", programLevel: "Advanced"),
        Student(name: "Chipo Mwale", email: "chipo@mcri.edu", programLevel: "Intermediate"),
        Student(name: "Tapiwa Nyandoro", email: "tapiwa@mcri.edu", programLevel: "Beginner")
    ]
}

extension Facilitator {
    static let sample: [Facilitator] = [
        Facilitator(name: "Sarah Johnson", email: "sarah@mcri.edu"),
        Facilitator(name: "James Williams", email: "james@mcri.edu"),
        Facilitator(name: "Emma Martinez", email: "emma@mcri.edu")
    ]
}

let demoStudentNames = [
    "Sebastian",
    "Wadzanayi",
    "Bongani",
    "Takudzwa",
    "Octavia",
    "Benard",
    "Audery",
    "Valerie",
    "Chapo",
    "Mthusi"
]

enum PortfolioSkillLibrary {
    static func starterSkills() -> [PortfolioSkill] {
        [
            PortfolioSkill(title: "Loops", icon: "chevron.left.forwardslash.chevron.right", status: "Demonstrated", category: "Technical"),
            PortfolioSkill(title: "Functions", icon: "function", status: "In progress", category: "Technical"),
            PortfolioSkill(title: "Communication", icon: "message.fill", status: "Demonstrated", category: "Soft"),
            PortfolioSkill(title: "Teamwork", icon: "person.3.fill", status: "Demonstrated", category: "Soft"),
            PortfolioSkill(title: "Problem Solving", icon: "lightbulb.fill", status: "Demonstrated", category: "Soft"),
            PortfolioSkill(title: "Swift", icon: "swift", status: "In progress", category: "Technical"),
            PortfolioSkill(title: "SwiftUI", icon: "rectangle.3.group.fill", status: "Demonstrated", category: "Technical"),
            PortfolioSkill(title: "GitHub", icon: "chevron.left.forwardslash.chevron.right", status: "Demonstrated", category: "Technical"),
            PortfolioSkill(title: "QA Testing", icon: "checkmark.shield.fill", status: "In progress", category: "Technical"),
            PortfolioSkill(title: "Time Management", icon: "clock.fill", status: "Demonstrated", category: "Soft"),
            PortfolioSkill(title: "Decision Making", icon: "arrow.triangle.branch", status: "In progress", category: "Soft"),
            PortfolioSkill(title: "Continuous Learning", icon: "book.fill", status: "Demonstrated", category: "Soft")
        ]
    }
}

// MARK: - App Data

final class SchoolDataManager: ObservableObject {
    @Published var catalogSkills: [Skill] = Skill.sample
    @Published var students: [Student] = Student.sample
    @Published var facilitators: [Facilitator] = Facilitator.sample
    @Published var allEvidences: [SkillEvidence] = []
    @Published var recentActivity: String = ""
    @Published var currentFacilitator: Facilitator?
    @Published var studentSkills: [StudentSkill] = []
    @Published var currentUserName: String = ""
    @Published var currentEmail: String = ""
    @Published var currentDetail: String = ""
    @Published var currentRole: UserRole?
    @Published var appearance: AppearanceSetting = AppearanceSetting(rawValue: UserDefaults.standard.string(forKey: "appearance") ?? "") ?? .system
    @Published var textSize: TextSizeSetting = {
        if UserDefaults.standard.object(forKey: "textSize") == nil {
            return .medium
        }
        return TextSizeSetting(rawValue: UserDefaults.standard.integer(forKey: "textSize")) ?? .medium
    }()
    @Published var notificationsEnabled: Bool = UserDefaults.standard.object(forKey: "notificationsEnabled") as? Bool ?? true
    @Published var notifications: [AppNotification] = []

    func evidence(for studentId: UUID) -> [SkillEvidence] {
        allEvidences.filter { $0.studentId == studentId }
    }

    func verifyEvidence(id: UUID, newStatus: EvidenceStatus, feedback: String) {
        guard let index = allEvidences.firstIndex(where: { $0.id == id }) else { return }
        allEvidences[index].status = newStatus
        allEvidences[index].facilitatorFeedback = feedback.trimmingCharacters(in: .whitespacesAndNewlines)
        recentActivity = "Evidence status was updated."
    }

    func updateStudent(id: UUID, name: String, email: String, programLevel: String) {
        guard let index = students.firstIndex(where: { $0.id == id }) else { return }

        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanLevel = programLevel.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty, !cleanEmail.isEmpty else { return }

        students[index].name = cleanName
        students[index].email = cleanEmail
        students[index].programLevel = cleanLevel
        recentActivity = "\(cleanName)'s profile was updated."
    }

    func student(with id: UUID) -> Student? {
        students.first { $0.id == id }
    }

    func signUpFacilitator(name: String, email: String) -> Bool {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty, cleanEmail.contains("@"), cleanEmail.contains(".") else {
            return false
        }

        if let existing = facilitators.first(where: { $0.email.localizedCaseInsensitiveCompare(cleanEmail) == .orderedSame }) {
            currentFacilitator = existing
        } else {
            let newFacilitator = Facilitator(name: cleanName, email: cleanEmail)
            facilitators.append(newFacilitator)
            currentFacilitator = newFacilitator
        }

        recentActivity = "\(cleanName) signed in as a facilitator."
        return true
    }

    func loadFacilitatorDemoData() {
        guard allEvidences.isEmpty else { return }

        let alex = students.first ?? Student(name: "Alex Johnson", email: "alex.johnson@example.com", programLevel: "Intermediate")
        let maya = students.count > 1 ? students[1] : alex
        let sam = students.count > 2 ? students[2] : alex

        studentSkills = [
            StudentSkill(studentId: alex.id, name: "Communication", category: .soft),
            StudentSkill(studentId: alex.id, name: "SwiftUI", category: .technical),
            StudentSkill(studentId: maya.id, name: "Teamwork", category: .soft),
            StudentSkill(studentId: maya.id, name: "HTML & CSS", category: .technical),
            StudentSkill(studentId: sam.id, name: "Leadership", category: .soft),
            StudentSkill(studentId: sam.id, name: "Data Structures", category: .technical)
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

    func signOutFacilitator() {
        signOut()
    }

    func signOut() {
        currentFacilitator = nil
        currentRole = nil
        currentUserName = ""
        currentEmail = ""
        currentDetail = ""
        notifications = []
    }

    func setAppearance(_ value: AppearanceSetting) {
        appearance = value
        UserDefaults.standard.set(value.rawValue, forKey: "appearance")
    }

    func setTextSize(_ value: TextSizeSetting) {
        textSize = value
        UserDefaults.standard.set(value.rawValue, forKey: "textSize")
    }

    func setNotificationsEnabled(_ value: Bool) {
        notificationsEnabled = value
        UserDefaults.standard.set(value, forKey: "notificationsEnabled")
    }

    func updateCurrentProfile(name: String, email: String, detail: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDetail = detail.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }

        currentUserName = cleanName
        currentEmail = cleanEmail
        currentDetail = cleanDetail

        switch currentRole {
        case .student:
            if let index = students.firstIndex(where: { $0.email.localizedCaseInsensitiveCompare(cleanEmail) == .orderedSame || $0.name == cleanName }) {
                students[index].name = cleanName
                students[index].email = cleanEmail
                if !cleanDetail.isEmpty {
                    students[index].programLevel = cleanDetail
                }
            }
        case .facilitator:
            if let facilitator = currentFacilitator,
               let index = facilitators.firstIndex(where: { $0.id == facilitator.id }) {
                facilitators[index].name = cleanName
                facilitators[index].email = cleanEmail
                currentFacilitator = facilitators[index]
            }
        case .admin, .employer, .none:
            break
        }

        pushNotification(title: "Profile updated", message: "Your \(currentRole?.rawValue ?? "account") details were saved.")
    }

    func pushNotification(title: String, message: String) {
        guard notificationsEnabled else { return }
        notifications.insert(
            AppNotification(title: title, message: message, date: Date()),
            at: 0
        )
    }

    func markNotificationRead(_ id: UUID) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications[index].isRead = true
    }

    var unreadNotificationCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    /// Opens the selected role portal. Matching directory accounts use their saved profile; any other username/password still enters that role.
    func login(username: String, password: String, role: UserRole) -> String? {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanUsername.isEmpty, !password.isEmpty else {
            return "Enter a username and password."
        }

        if let known = RoleAccount.directory.first(where: {
            $0.username.localizedCaseInsensitiveCompare(cleanUsername) == .orderedSame
        }) {
            if known.role != role {
                return "That username belongs to the \(known.role.rawValue) portal. Select \(known.role.rawValue) to continue."
            }
            if known.password != password {
                return "Incorrect password."
            }
            applyLoggedInAccount(known)
            return nil
        }

        applyLoggedInAccount(
            RoleAccount(
                username: cleanUsername,
                password: password,
                displayName: prettyName(from: cleanUsername),
                email: "\(cleanUsername.lowercased())@mcri.edu",
                role: role
            )
        )
        return nil
    }

    private func prettyName(from username: String) -> String {
        username
            .replacingOccurrences(of: ".", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }

    private func applyLoggedInAccount(_ account: RoleAccount) {
        currentUserName = account.displayName
        currentEmail = account.email
        currentRole = account.role
        loadFacilitatorDemoData()

        switch account.role {
        case .facilitator:
            currentDetail = "Facilitator"
            _ = signUpFacilitator(name: account.displayName, email: account.email)
        case .student:
            currentDetail = "MCRI"
            if !students.contains(where: { $0.email.localizedCaseInsensitiveCompare(account.email) == .orderedSame }) {
                students.append(Student(name: account.displayName, email: account.email, programLevel: "Beginner"))
            }
        case .admin:
            currentDetail = "MCRI Administration"
        case .employer:
            currentDetail = "Hiring Partner"
        }

        notifications = [
            AppNotification(
                title: "Welcome, \(account.displayName)",
                message: "You are signed in to the \(account.role.portalTitle).",
                date: Date()
            ),
            AppNotification(
                title: "Portfolio activity",
                message: account.role == .facilitator
                    ? "You have evidence waiting for review."
                    : "Your workspace is ready to use.",
                date: Date().addingTimeInterval(-3600)
            )
        ]
    }

    func skills(for studentId: UUID, category: SkillCategory) -> [StudentSkill] {
        studentSkills.filter { $0.studentId == studentId && $0.category == category }
    }

    func addSkill(studentId: UUID, name: String, category: SkillCategory) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }

        studentSkills.append(StudentSkill(studentId: studentId, name: cleanName, category: category))
        recentActivity = "\(cleanName) (\(category.rawValue)) was added."
    }

    func deleteSkill(id: UUID) {
        guard let skill = studentSkills.first(where: { $0.id == id }) else { return }
        studentSkills.removeAll { $0.id == id }
        recentActivity = "\(skill.name) was deleted."
    }

}
