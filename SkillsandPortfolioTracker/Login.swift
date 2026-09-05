//
//  Login.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 5/9/2026.
//
//
//  Login.swift
//  SkillsandPortfolioTracker
//  Created by wadzie on 5/9/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var dataManager: SchoolDataManager

    @State private var selectedRole: UserRole = .student
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showPassword = false
    @State private var didLogin = false

    private var canSubmit: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Log in")
                        .font(.system(size: 32, weight: .bold))
                    Text("Select a role and sign in. You’ll open that role’s portal.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("I am logging in as")
                        .font(.subheadline.weight(.semibold))

                    Picker("Role", selection: $selectedRole) {
                        ForEach(UserRole.allCases) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedRole) { _, _ in
                        errorMessage = ""
                    }
                }

                Text("Continues to the \(selectedRole.portalTitle)")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(PortfolioTheme.teal)

                VStack(spacing: 14) {
                    loginField(title: "Username", text: $username, placeholder: "Username", isSecure: false)
                    loginField(title: "Password", text: $password, placeholder: "Password", isSecure: !showPassword)

                    Button {
                        showPassword.toggle()
                    } label: {
                        Text(showPassword ? "Hide password" : "Show password")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(PortfolioTheme.teal)
                    }
                }

                Button(action: submit) {
                    Text("Log in to \(selectedRole.portalTitle)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            PortfolioTheme.navy.opacity(canSubmit ? 1 : 0.4),
                            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                        )
                }
                .disabled(!canSubmit)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Sign in")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Could not log in", isPresented: Binding(
            get: { !errorMessage.isEmpty },
            set: { if !$0 { errorMessage = "" } }
        )) {
            Button("OK", role: .cancel) { errorMessage = "" }
        } message: {
            Text(errorMessage)
        }
        // MARK: - Navigation stack destination
        // Pushes to the specific portal view file that matches the role
        // that was selected at the moment of a successful login.
        .navigationDestination(isPresented: $didLogin) {
            destinationView
        }
    }

    /// Maps the logged-in role to its corresponding view file.
    @ViewBuilder
    private var destinationView: some View {
        switch selectedRole {
        case .student:
            Studentlist()
        case .facilitator:
            FacilitatorView()
        case .admin:
            AdminView()
        case .employer:
            EmployerView()
        }
    }

    private func loginField(
        title: String,
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))

            Group {
                if isSecure {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                }
            }
            .padding(14)
            .background(
                Color(.secondarySystemBackground),
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
        }
    }

    private func submit() {
        if let message = dataManager.login(username: username, password: password, role: selectedRole) {
            errorMessage = message
        } else {
            didLogin = true
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(SchoolDataManager())
    }
}
