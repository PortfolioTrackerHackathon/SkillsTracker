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
        // MARK: - Wrong credentials sheet
        .sheet(isPresented: Binding(
            get: { !errorMessage.isEmpty },
            set: { if !$0 { errorMessage = "" } }
        )) {
            wrongCredentialsSheet
        }
        // MARK: - Navigation stack destination
        .navigationDestination(isPresented: $didLogin) {
            destinationView
        }
    }

    /// The sheet shown when login fails for the selected role.
    private var wrongCredentialsSheet: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.red)

            Text("Wrong credentials")
                .font(.title3.weight(.semibold))

            Text(errorMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button {
                errorMessage = ""
            } label: {
                Text("OK")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(PortfolioTheme.navy, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()
        }
        .presentationDetents([.height(280)])
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

    /// Checks the entered username/password against the hardcoded
    /// credentials for the selected role and shows the "Wrong credentials"
    /// sheet on failure.
    private func submit() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        let isValid: Bool
        switch selectedRole {
        case .student:
            isValid = trimmedUsername == "student" && password == "student123"
        case .facilitator:
            isValid = trimmedUsername == "facilitator" && password == "facilitator123"
        case .employer:
            isValid = trimmedUsername == "employer" && password == "employer123"
        case .admin:
            isValid = trimmedUsername == "manager" && password == "manager123"
        }

        if isValid {
            didLogin = true
        } else {
            errorMessage = "Wrong credentials"
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(SchoolDataManager())
    }
}
