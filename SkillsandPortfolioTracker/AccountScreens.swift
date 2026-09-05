//
//  AccountScreens.swift
//  SkillsandPortfolioTracker
//
//  Shared settings, notifications, profile editing, and sign out.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var dataManager: SchoolDataManager

    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: appearanceBinding) {
                    ForEach(AppearanceSetting.allCases) { setting in
                        Text(setting.rawValue).tag(setting)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Text size") {
                Picker("Text size", selection: textSizeBinding) {
                    ForEach(TextSizeSetting.allCases) { size in
                        Text(size.label).tag(size)
                    }
                }
                .pickerStyle(.segmented)

                Text("This is a preview of your selected text size.")
                    .foregroundStyle(.secondary)
            }

            Section("Notifications") {
                Toggle("Enable notifications", isOn: notificationsBinding)
            }

            Section("Account") {
                LabeledContent("Signed in as", value: dataManager.currentUserName)
                LabeledContent("Role", value: dataManager.currentRole?.rawValue ?? "—")
            }

            Section {
                SignOutButton()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var appearanceBinding: Binding<AppearanceSetting> {
        Binding(
            get: { dataManager.appearance },
            set: { dataManager.setAppearance($0) }
        )
    }

    private var textSizeBinding: Binding<TextSizeSetting> {
        Binding(
            get: { dataManager.textSize },
            set: { dataManager.setTextSize($0) }
        )
    }

    private var notificationsBinding: Binding<Bool> {
        Binding(
            get: { dataManager.notificationsEnabled },
            set: { dataManager.setNotificationsEnabled($0) }
        )
    }
}

struct NotificationsView: View {
    @EnvironmentObject private var dataManager: SchoolDataManager

    var body: some View {
        Group {
            if !dataManager.notificationsEnabled {
                ContentUnavailableView(
                    "Notifications Off",
                    systemImage: "bell.slash",
                    description: Text("Turn them on in Settings to receive updates.")
                )
            } else if dataManager.notifications.isEmpty {
                ContentUnavailableView(
                    "No Notifications",
                    systemImage: "bell",
                    description: Text("You're all caught up.")
                )
            } else {
                List {
                    ForEach(dataManager.notifications) { item in
                        Button {
                            dataManager.markNotificationRead(item.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if !item.isRead {
                                        Circle()
                                            .fill(PortfolioTheme.teal)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                Text(item.message)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(item.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileView: View {
    @EnvironmentObject private var dataManager: SchoolDataManager
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var detail = ""

    private var detailTitle: String {
        switch dataManager.currentRole {
        case .student: return "Program"
        case .employer: return "Organization"
        case .admin: return "Department"
        case .facilitator: return "Title"
        case .none: return "Details"
        }
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Full name", text: $name)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    TextField(detailTitle, text: $detail)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dataManager.updateCurrentProfile(name: name, email: email, detail: detail)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                name = dataManager.currentUserName
                email = dataManager.currentEmail
                detail = dataManager.currentDetail
            }
        }
    }
}

struct SignOutButton: View {
    @EnvironmentObject private var dataManager: SchoolDataManager
    @State private var showConfirm = false

    var body: some View {
        Button("Sign Out", role: .destructive) {
            showConfirm = true
        }
        .alert("Sign out?", isPresented: $showConfirm) {
            Button("Sign Out", role: .destructive) {
                dataManager.signOut()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You will return to the login page.")
        }
    }
}
