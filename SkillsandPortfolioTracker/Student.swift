//
// Student.swift
// SkillsandPortfolioTracker
//
// Created by wadzie on 4/9/2026.
//

import SwiftUI
import PhotosUI
import AVKit

// MARK: - Home View

struct HomeView: View {

    @EnvironmentObject private var dataManager: SchoolDataManager

    let userName: String

    let teal = Color(red: 0.02, green: 0.67, blue: 0.63)
    let navy = Color(red: 0.02, green: 0.08, blue: 0.25)

    @State private var skills: [PortfolioSkill] = PortfolioSkillLibrary.starterSkills()

    @State private var showAddSkill = false
    @State private var showNotifications = false

    private var displayName: String {
        dataManager.currentUserName.isEmpty ? userName : dataManager.currentUserName
    }
    @State private var evidenceItems: [EvidenceItem] = [
        EvidenceItem(title: "LTC Challenge 04", description: "Swift loops challenge", type: "Assessment"),
        EvidenceItem(title: "SwiftUI Project", description: "Skills Portfolio Tracker", type: "Project"),
        EvidenceItem(title: "Teamwork Project", description: "Group project evidence", type: "Video")
    ]

    private var totalSkills: Int {
        skills.count
    }

    private var demonstratedSkills: Int {
        skills.filter { $0.status == "Demonstrated" }.count
    }

    private var progress: Double {
        guard totalSkills > 0 else {
            return 0
        }

        return Double(demonstratedSkills) / Double(totalSkills)
    }

    private var percentage: Int {
        Int(progress * 100)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour < 12 {
            return "Good morning,"
        } else if hour < 17 {
            return "Good afternoon,"
        } else {
            return "Good evening,"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // MARK: Header

                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(navy)
                                    .frame(width: 58, height: 58)

                                Text(String(displayName.prefix(1)).uppercased())
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(teal)
                            }

                            Spacer()

                            Button {
                                showNotifications = true
                            } label: {
                                Image(systemName: dataManager.unreadNotificationCount > 0 ? "bell.badge" : "bell")
                                    .font(.system(size: 23))
                                    .foregroundStyle(navy)
                                    .padding(16)
                                    .background(Color(.systemBackground))
                                    .clipShape(Circle())
                            }
                        }

                        // MARK: Greeting

                        VStack(alignment: .leading, spacing: 0) {
                            Text(greeting)
                                .font(.system(size: 38, weight: .bold))
                                .foregroundStyle(navy)

                            Text(displayName)
                                .font(.system(size: 38, weight: .bold))
                                .foregroundStyle(navy)
                        }

                        progressCard

                        manageSkillsButton

                        portfolioSlider

                        Text("Continue building your skills")
                            .font(.system(size: 21, weight: .bold))
                            .foregroundStyle(navy)

                        skillSlider

                        Text("Recent activity")
                            .font(.system(size: 21, weight: .bold))
                            .foregroundStyle(navy)
                            .padding(.top, 5)

                        activityCard

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }

                bottomNavigation
            }
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .bottom)
            .sheet(isPresented: $showAddSkill) {
                AddSkillView(
                    skills: $skills,
                    teal: teal,
                    navy: navy
                )
            }
            .sheet(isPresented: $showNotifications) {
                NavigationStack { NotificationsView() }
            }
        }
    }

    // MARK: - Manage Skills

    private var manageSkillsButton: some View {
        NavigationLink {
            SkillsView(
                skills: $skills,
                teal: teal,
                navy: navy
            )
        } label: {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(teal)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Manage your skills")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(navy)

                    Text("Add, edit or delete your skills")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(teal)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(
                        color: .black.opacity(0.05),
                        radius: 7,
                        y: 3
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Progress Card

    private var progressCard: some View {
        HStack(spacing: 20) {

            VStack(alignment: .leading, spacing: 5) {
                Text("\(demonstratedSkills) of \(totalSkills)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(teal)

                Text("skills demonstrated")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(navy)

                Text(progressMessage)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                    .padding(.top, 12)
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(
                        Color.gray.opacity(0.15),
                        lineWidth: 12
                    )

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        teal,
                        style: StrokeStyle(
                            lineWidth: 12,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(percentage)%")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(teal)

                    Text("complete")
                        .font(.system(size: 13))
                        .foregroundStyle(teal)
                }
            }
            .frame(width: 120, height: 120)
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color(
                        red: 0.95,
                        green: 0.98,
                        blue: 0.98
                    )
                )
        )
    }

    private var progressMessage: String {
        if percentage == 100 {
            return "Amazing! You've completed everything!"
        } else if percentage >= 75 {
            return "You're almost there, keep going!"
        } else if percentage >= 50 {
            return "Great progress, keep building!"
        } else {
            return "Keep going, you're doing great!"
        }
    }

    // MARK: - Skill Slider

    private var skillSlider: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(skills) { skill in
                    SkillCard(
                        icon: skill.icon,
                        title: skill.title,
                        status: skill.status,
                        teal: teal,
                        navy: navy
                    )
                    .frame(width: 175)
                }
            }
        }
    }

    // MARK: - Portfolio Slider

    private var portfolioSlider: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {

                // VIEW PORTFOLIO

                NavigationLink {
                    PortfolioView(
                        skills: skills,
                        teal: teal,
                        navy: navy
                    )
                } label: {
                    PortfolioCard(
                        title: "View portfolio",
                        subtitle: "See your progress",
                        icon: "folder",
                        teal: teal,
                        navy: navy
                    )
                }
                .buttonStyle(.plain)

                // ADD EVIDENCE

                NavigationLink {
                    EvidenceView(
                        teal: teal,
                        navy: navy,
                        evidence: $evidenceItems
                    )
                } label: {
                    PortfolioCard(
                        title: "Add evidence",
                        subtitle: "Attach photos or videos",
                        icon: "plus.circle",
                        teal: teal,
                        navy: navy
                    )
                }
                .buttonStyle(.plain)

                // PROJECTS

                PortfolioCard(
                    title: "Your projects",
                    subtitle: "View your completed work",
                    icon: "hammer.fill",
                    teal: teal,
                    navy: navy
                )
            }
        }
    }

    // MARK: - Activity

    private var activityCard: some View {
        HStack(spacing: 20) {

            ZStack {
                Circle()
                    .fill(
                        Color(
                            red: 0.95,
                            green: 0.98,
                            blue: 0.98
                        )
                    )
                    .frame(width: 60, height: 60)

                Image(systemName: "doc.text")
                    .font(.system(size: 25))
                    .foregroundStyle(teal)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("LTC Challenge 04 submitted for review")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(navy)

                Text("Today, 8:30 AM")
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }

            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(
                    color: .black.opacity(0.04),
                    radius: 8,
                    y: 3
                )
        )
    }

    // MARK: - Bottom Navigation

    private var bottomNavigation: some View {
        HStack {

            // HOME

            NavigationItem(
                icon: "house.fill",
                title: "Home",
                selected: true,
                teal: teal
            )

            Spacer()

            // SKILLS

            NavigationLink {
                SkillsView(
                    skills: $skills,
                    teal: teal,
                    navy: navy
                )
            } label: {
                NavigationItem(
                    icon: "chart.bar.fill",
                    title: "Skills",
                    selected: false,
                    teal: teal
                )
            }
            .buttonStyle(.plain)

            Spacer()

            // EVIDENCE

            NavigationLink {
                EvidenceView(
                    teal: teal,
                    navy: navy,
                    evidence: $evidenceItems
                )
            } label: {
                NavigationItem(
                    icon: "folder.fill",
                    title: "Evidence",
                    selected: false,
                    teal: teal
                )
            }
            .buttonStyle(.plain)

            Spacer()

            // PROFILE

            NavigationLink {
                ProfileView(
                    userName: displayName,
                    teal: teal,
                    navy: navy
                )
            } label: {
                NavigationItem(
                    icon: "person.fill",
                    title: "Profile",
                    selected: false,
                    teal: teal
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 30)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            Color.white
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 10,
                    y: -3
                )
        )
    }
}

// MARK: - Portfolio View

struct PortfolioView: View {

    let skills: [PortfolioSkill]
    let teal: Color
    let navy: Color

    private var demonstratedSkills: [PortfolioSkill] {
        skills.filter {
            $0.status == "Demonstrated"
        }
    }

    private var inProgressSkills: [PortfolioSkill] {
        skills.filter {
            $0.status == "In progress"
        }
    }
    private var notStartedSkills: [PortfolioSkill] {
        skills.filter {
            $0.status == "Not started"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("My Portfolio")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(navy)

                    Text("A collection of your skills and evidence.")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }

                HStack(spacing: 12) {

                    PortfolioStatCard(
                        number: "\(skills.count)",
                        title: "Total Skills",
                        icon: "star.fill",
                        teal: teal,
                        navy: navy
                    )

                    PortfolioStatCard(
                        number: "\(demonstratedSkills.count)",
                        title: "Demonstrated",
                        icon: "checkmark.circle.fill",
                        teal: teal,
                        navy: navy
                    )
                }

                Text("Demonstrated Skills")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(navy)

                ForEach(demonstratedSkills) { skill in
                    PortfolioSkillRow(
                        skill: skill,
                        teal: teal,
                        navy: navy
                    )
                }

                Text("Skills In Progress")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(navy)
                    .padding(.top, 5)

                ForEach(inProgressSkills) { skill in
                    PortfolioSkillRow(
                        skill: skill,
                        teal: teal,
                        navy: navy
                    )
                }
            }
            .padding(20)
        }
        .background(Color.white)
        .navigationTitle("Portfolio")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Portfolio Stat Card

struct PortfolioStatCard: View {

    let number: String
    let title: String
    let icon: String
    let teal: Color
    let navy: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(teal)

            Text(number)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(navy)

            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    Color(
                        red: 0.95,
                        green: 0.98,
                        blue: 0.98
                    )
                )
        )
    }
}

// MARK: - Portfolio Skill Row

struct PortfolioSkillRow: View {

    let skill: PortfolioSkill
    let teal: Color
    let navy: Color

    var body: some View {
        HStack(spacing: 15) {

            ZStack {
                Circle()
                    .fill(
                        Color(
                            red: 0.95,
                            green: 0.98,
                            blue: 0.98
                        )
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: skill.icon)
                    .foregroundStyle(
                        skill.status == "Demonstrated"
                        ? teal
                        : .orange
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(skill.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(navy)

                Text(skill.status)
                    .font(.system(size: 13))
                    .foregroundStyle(
                        skill.status == "Demonstrated"
                        ? teal
                        : .orange
                    )
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(teal)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(
                    color: .black.opacity(0.04),
                    radius: 7,
                    y: 3
                )
        )
    }
}

// MARK: - Evidence Model


struct EvidenceView: View {

    let teal: Color
    let navy: Color
    @Binding var evidence: [EvidenceItem]

    @State private var showAddEvidence = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header

                VStack(alignment: .leading, spacing: 8) {
                    Text("My Evidence")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(navy)

                    Text("Attach photos, videos and other evidence that proves your skills.")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }

                // Add Evidence Button

                Button {
                    showAddEvidence = true
                } label: {
                    HStack {

                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 25))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Add Evidence")
                                .font(.system(size: 18, weight: .bold))

                            Text("Attach a photo or video")
                                .font(.system(size: 14))
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.white)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(teal)
                    )
                }
                .buttonStyle(.plain)

                // Evidence List

                Text("Your Evidence")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(navy)

                ForEach(evidence) { item in
                    StudentEvidenceRow(
                        item: item,
                        teal: teal,
                        navy: navy
                    )
                }

                Spacer(minLength: 30)
            }
            .padding(20)
        }
        .background(Color.white)
        .navigationTitle("Evidence")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddEvidence) {
            AddEvidenceView(
                teal: teal,
                navy: navy,
                evidence: $evidence
            )
        }
    }
}

// MARK: - Evidence Row

struct StudentEvidenceRow: View {

    let item: EvidenceItem
    let teal: Color
    let navy: Color

    var body: some View {
        HStack(spacing: 15) {

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        Color(
                            red: 0.95,
                            green: 0.98,
                            blue: 0.98
                        )
                    )
                    .frame(width: 55, height: 55)

                Image(
                    systemName: item.type == "Video"
                    ? "video.fill"
                    : "doc.fill"
                )
                .foregroundStyle(teal)
                .font(.system(size: 22))
            }

            VStack(alignment: .leading, spacing: 5) {

                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(navy)

                Text(item.description)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)

                Text(item.type)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(teal)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(teal)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(
                    color: .black.opacity(0.04),
                    radius: 7,
                    y: 3
                )
        )
    }
}

// MARK: - Add Evidence View

struct AddEvidenceView: View {

    @Environment(\.dismiss) private var dismiss

    let teal: Color
    let navy: Color
    @Binding var evidence: [EvidenceItem]

    @State private var evidenceTitle = ""
    @State private var description = ""

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedVideo: PhotosPickerItem?

    @State private var photoData: Data?
    @State private var videoData: Data?

    @State private var showPhotoPicker = false
    @State private var showVideoPicker = false

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Evidence Information

                Section("Evidence Information") {

                    TextField(
                        "Evidence title",
                        text: $evidenceTitle
                    )

                    TextField(
                        "Description",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }

                // MARK: Attach Photo

                Section("Attach Photo") {

                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        HStack {

                            Image(systemName: "photo.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(teal)

                            VStack(alignment: .leading) {
                                Text("Choose Photo")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(navy)

                                Text(
                                    photoData == nil
                                    ? "Select a photo from your device"
                                    : "Photo attached"
                                )
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                            }

                            Spacer()

                            Image(
                                systemName: photoData == nil
                                ? "chevron.right"
                                : "checkmark.circle.fill"
                            )
                            .foregroundStyle(teal)
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                photoData = data
                            }
                        }
                    }

                    if let photoData = photoData,
                       let uiImage = UIImage(data: photoData) {

                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 15)
                            )
                    }
                }

                // MARK: Attach Video

                Section("Attach Video") {

                    PhotosPicker(
                        selection: $selectedVideo,
                        matching: .videos
                    ) {
                        HStack {

                            Image(systemName: "video.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(teal)

                            VStack(alignment: .leading) {

                                Text("Choose Video")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(navy)

                                Text(
                                    videoData == nil
                                    ? "Select a video from your device"
                                    : "Video attached"
                                )
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                            }

                            Spacer()

                            Image(
                                systemName: videoData == nil
                                ? "chevron.right"
                                : "checkmark.circle.fill"
                            )
                            .foregroundStyle(teal)
                        }
                    }
                    .onChange(of: selectedVideo) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                videoData = data
                            }
                        }
                    }

                    if videoData != nil {
                        HStack {
                            Image(systemName: "video.fill")
                                .foregroundStyle(teal)

                            Text("Video attached successfully")
                                .foregroundStyle(navy)

                            Spacer()

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(teal)
                        }
                    }
                }

                // MARK: Save Evidence

                Section {

                    Button {
                        saveEvidence()
                    } label: {
                        Text("Save Evidence")
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(teal)
                    .disabled(
                        evidenceTitle
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .navigationTitle("Add Evidence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveEvidence() {
        let trimmedTitle = evidenceTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let type: String
        if videoData != nil {
            type = "Video"
        } else if photoData != nil {
            type = "Photo"
        } else {
            type = "Document"
        }

        evidence.append(
            EvidenceItem(
                title: trimmedTitle,
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                type: type,
                fileData: photoData ?? videoData
            )
        )
        dismiss()
    }
}

// MARK: - Profile View

struct ProfileView: View {

    @EnvironmentObject private var dataManager: SchoolDataManager

    let userName: String
    let teal: Color
    let navy: Color

    @State private var showEdit = false
    @State private var showSettings = false
    @State private var showNotifications = false

    private var displayName: String {
        dataManager.currentUserName.isEmpty ? userName : dataManager.currentUserName
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {

                // MARK: Profile Header

                VStack(spacing: 12) {

                    ZStack {
                        Circle()
                            .fill(navy)
                            .frame(width: 110, height: 110)

                        Text(
                            String(
                                displayName.prefix(1)
                            )
                            .uppercased()
                        )
                        .font(
                            .system(
                                size: 55,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(teal)
                    }

                    Text(displayName)
                        .font(
                            .system(
                                size: 28,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(navy)

                    Text("MCRI Student")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

                // MARK: Profile Information

                VStack(alignment: .leading, spacing: 0) {

                    Text("Profile Information")
                        .font(
                            .system(
                                size: 21,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(navy)
                        .padding(.bottom, 10)

                    ProfileRow(
                        icon: "person.fill",
                        title: "Name",
                        value: displayName,
                        teal: teal,
                        navy: navy
                    )

                    ProfileRow(
                        icon: "envelope.fill",
                        title: "Email",
                        value: dataManager.currentEmail.isEmpty ? "—" : dataManager.currentEmail,
                        teal: teal,
                        navy: navy
                    )

                    ProfileRow(
                        icon: "graduationcap.fill",
                        title: "Program",
                        value: dataManager.currentDetail.isEmpty ? "MCRI" : dataManager.currentDetail,
                        teal: teal,
                        navy: navy
                    )

                    ProfileRow(
                        icon: "swift",
                        title: "Focus",
                        value: "Swift & iOS Development",
                        teal: teal,
                        navy: navy
                    )

                    ProfileRow(
                        icon: "folder.fill",
                        title: "Portfolio",
                        value: "Skills & Evidence",
                        teal: teal,
                        navy: navy
                    )
                }

                // MARK: Account

                VStack(alignment: .leading, spacing: 10) {

                    Text("Account")
                        .font(
                            .system(
                                size: 21,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(navy)

                    ProfileAction(
                        icon: "pencil",
                        title: "Edit Profile",
                        teal: teal,
                        navy: navy,
                        action: { showEdit = true }
                    )

                    ProfileAction(
                        icon: "bell.fill",
                        title: "Notifications",
                        teal: teal,
                        navy: navy,
                        action: { showNotifications = true }
                    )

                    ProfileAction(
                        icon: "gearshape.fill",
                        title: "Settings",
                        teal: teal,
                        navy: navy,
                        action: { showSettings = true }
                    )

                    SignOutButton()
                        .frame(maxWidth: .infinity)
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.04), radius: 7, y: 3)
                        )
                }

                Spacer(minLength: 30)
            }
            .padding(20)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEdit) {
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

// MARK: - Profile Row

struct ProfileRow: View {

    let icon: String
    let title: String
    let value: String
    let teal: Color
    let navy: Color

    var body: some View {
        HStack(spacing: 15) {

            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(teal)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)

                Text(value)
                    .font(
                        .system(
                            size: 16,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(navy)
            }

            Spacer()
        }
        .padding(.vertical, 13)
    }
}

// MARK: - Profile Action

struct ProfileAction: View {

    let icon: String
    let title: String
    let teal: Color
    let navy: Color
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack {

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(teal)
                    .frame(width: 30)

                Text(title)
                    .font(
                        .system(
                            size: 16,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(navy)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(teal)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: .black.opacity(0.04),
                        radius: 7,
                        y: 3
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Skills View

struct SkillsView: View {

    @Binding var skills: [PortfolioSkill]

    let teal: Color
    let navy: Color

    @State private var showAddSkill = false

    var body: some View {
        List {

            Section("Technical Skills") {
                skillSection(category: "Technical")
            }

            Section("Soft Skills") {
                skillSection(category: "Soft")
            }
        }
        .navigationTitle("My Skills")
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button {
                    showAddSkill = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(teal)
                }
            }
        }
        .sheet(isPresented: $showAddSkill) {

            AddSkillView(
                skills: $skills,
                teal: teal,
                navy: navy
            )
        }
    }

    @ViewBuilder
    private func skillSection(category: String) -> some View {
        let indices = skills.indices.filter { skills[$0].category == category }

        ForEach(indices, id: \.self) { index in
            StudentSkillRow(
                skill: $skills[index],
                teal: teal,
                navy: navy
            )
        }
        .onDelete { offsets in
            let idsToDelete = offsets.map { indices[$0] }.map { skills[$0].id }
            skills.removeAll { idsToDelete.contains($0.id) }
        }
    }
}

// MARK: - Skill Row

struct StudentSkillRow: View {

    @Binding var skill: PortfolioSkill
    let teal: Color
    let navy: Color

    @State private var showEdit = false

    var body: some View {

        HStack(spacing: 15) {

            Image(systemName: skill.icon)
                .font(.system(size: 20))
                .foregroundStyle(
                    skill.status == "Demonstrated"
                    ? teal
                    : .orange
                )
                .frame(width: 35)

            VStack(alignment: .leading, spacing: 4) {

                Text(skill.title)
                    .font(
                        .system(
                            size: 17,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(navy)

                Text(skill.status)
                    .font(.system(size: 13))
                    .foregroundStyle(
                        skill.status == "Demonstrated"
                        ? teal
                        : .orange
                    )
            }

            Spacer()

            Button {
                showEdit = true
            } label: {
                Image(systemName: "pencil")
                    .foregroundStyle(teal)
            }
            .buttonStyle(.borderless)
        }
        .sheet(isPresented: $showEdit) {
            EditPortfolioSkillView(
                skill: $skill,
                teal: teal,
                navy: navy
            )
        }
    }
}

struct EditPortfolioSkillView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var skill: PortfolioSkill
    let teal: Color
    let navy: Color

    @State private var title = ""
    @State private var status = "In progress"
    @State private var category = "Technical"

    var body: some View {
        NavigationStack {
            Form {
                Section("Skill") {
                    TextField("Skill name", text: $title)
                    Picker("Category", selection: $category) {
                        Text("Technical").tag("Technical")
                        Text("Soft").tag("Soft")
                    }
                    Picker("Status", selection: $status) {
                        Text("In progress").tag("In progress")
                        Text("Demonstrated").tag("Demonstrated")
                        Text("Not started").tag("Not started")
                    }
                }
            }
            .navigationTitle("Edit Skill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        skill.title = trimmed
                        skill.status = status
                        skill.category = category
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                title = skill.title
                status = skill.status
                category = skill.category
            }
        }
    }
}

// MARK: - Add Skill View

struct AddSkillView: View {

    @Environment(\.dismiss) private var dismiss

    @Binding var skills: [PortfolioSkill]

    let teal: Color
    let navy: Color

    @State private var skillName = ""
    @State private var category = "Technical"
    @State private var status = "In progress"
    @State private var icon = "star.fill"

    let icons = [
        "star.fill",
        "swift",
        "function",
        "message.fill",
        "person.3.fill",
        "lightbulb.fill",
        "clock.fill",
        "book.fill",
        "checkmark.shield.fill",
        "folder.fill",
        "hammer.fill"
    ]

    var body: some View {

        NavigationStack {

            Form {

                Section("Skill Information") {

                    TextField(
                        "Skill name",
                        text: $skillName
                    )

                    Picker(
                        "Category",
                        selection: $category
                    ) {

                        Text("Technical")
                            .tag("Technical")

                        Text("Soft")
                            .tag("Soft")
                    }

                    Picker(
                        "Status",
                        selection: $status
                    ) {

                        Text("In progress")
                            .tag("In progress")

                        Text("Demonstrated")
                            .tag("Demonstrated")
                    }
                }

                Section("Choose Icon") {

                    LazyVGrid(
                        columns: [
                            GridItem(
                                .adaptive(
                                    minimum: 55
                                )
                            )
                        ],
                        spacing: 15
                    ) {

                        ForEach(
                            icons,
                            id: \.self
                        ) { iconName in

                            Button {

                                icon = iconName

                            } label: {

                                Image(systemName: iconName)
                                    .font(
                                        .system(size: 22)
                                    )
                                    .foregroundStyle(
                                        icon == iconName
                                        ? .white
                                        : teal
                                    )
                                    .frame(
                                        width: 50,
                                        height: 50
                                    )
                                    .background(
                                        icon == iconName
                                        ? teal
                                        : Color.gray.opacity(0.1)
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 12
                                        )
                                    )
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }

                Section {

                    Button {

                        addSkill()

                    } label: {

                        Text("Add Skill")
                            .font(
                                .system(
                                    size: 17,
                                    weight: .bold
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(teal)
                    .disabled(
                        skillName
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .navigationTitle("Add Skill")
            .navigationBarTitleDisplayMode(.inline)
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

    private func addSkill() {

        let newSkill = PortfolioSkill(
            title: skillName,
            icon: icon,
            status: status,
            category: category
        )

        skills.append(newSkill)

        dismiss()
    }
}

// MARK: - Skill Card

struct SkillCard: View {

    let icon: String
    let title: String
    let status: String
    let teal: Color
    let navy: Color

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                ZStack {

                    Circle()
                        .fill(
                            Color(
                                red: 0.95,
                                green: 0.98,
                                blue: 0.98
                            )
                        )
                        .frame(
                            width: 45,
                            height: 45
                        )

                    Image(systemName: icon)
                        .font(
                            .system(
                                size: 19,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            status == "Demonstrated"
                            ? teal
                            : .orange
                        )
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(teal)
            }

            Text(title)
                .font(
                    .system(
                        size: 16,
                        weight: .bold
                    )
                )
                .foregroundStyle(navy)
                .lineLimit(1)

            HStack(spacing: 7) {

                Image(
                    systemName:
                        status == "Demonstrated"
                        ? "checkmark.circle.fill"
                        : "clock"
                )
                .foregroundStyle(
                    status == "Demonstrated"
                    ? teal
                    : .orange
                )

                Text(status)
                    .font(.system(size: 12))
                    .foregroundStyle(
                        status == "Demonstrated"
                        ? teal
                        : .orange
                    )
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 17)
                .fill(Color.white)
                .shadow(
                    color: .black.opacity(0.04),
                    radius: 7,
                    y: 3
                )
        )
    }
}

// MARK: - Portfolio Card

struct PortfolioCard: View {

    let title: String
    let subtitle: String
    let icon: String
    let teal: Color
    let navy: Color

    var body: some View {

        HStack(spacing: 20) {

            ZStack {

                Circle()
                    .fill(
                        Color(
                            red: 0.95,
                            green: 0.98,
                            blue: 0.98
                        )
                    )
                    .frame(
                        width: 58,
                        height: 58
                    )

                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundStyle(teal)
            }

            VStack(alignment: .leading, spacing: 5) {

                Text(title)
                    .font(
                        .system(
                            size: 19,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(navy)

                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(
                    .system(
                        size: 22,
                        weight: .medium
                    )
                )
                .foregroundStyle(teal)
        }
        .padding(20)
        .frame(width: 340)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 7,
            y: 3
        )
    }
}

// MARK: - Navigation Item

struct NavigationItem: View {

    let icon: String
    let title: String
    let selected: Bool
    let teal: Color

    var body: some View {

        VStack(spacing: 5) {

            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(
                    selected
                    ? teal
                    : .gray
                )

            Text(title)
                .font(
                    .system(
                        size: 13,
                        weight: selected
                        ? .medium
                        : .regular
                    )
                )
                .foregroundStyle(
                    selected
                    ? teal
                    : .gray
                )
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView(
        userName: demoStudentNames[0]
    )
    .environmentObject(SchoolDataManager())
}
