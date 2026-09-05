//
//  ManageUsersView.swift
//  SkillsandPortfolioTracker
//
//  Created by octavia on 5/9/2026.
//

import Foundation
//
//  ManageUsersView.swift
//  Skills Portfolio Tracker
//
//  User management screen for students and facilitators.
//

import SwiftUI

// MARK: - Manage Users Sheet

struct ManageUsersView: View {
    @Binding var students: [Student]
    @Binding var facilitators: [Facilitator]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: String = "Students"
    @State private var searchText = ""
    @State private var userToDelete: (type: String, user: Any)?
    @State private var showDeleteConfirmation = false
    @State private var showingAddUser = false
    @State private var editingUser: (type: String, user: Any)?
    @State private var showingEditUser = false

    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return students
        }
        return students.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    var filteredFacilitators: [Facilitator] {
        if searchText.isEmpty {
            return facilitators
        }
        return facilitators.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("User Type", selection: $selectedTab) {
                    Text("Students (\(students.count))").tag("Students")
                    Text("Facilitators (\(facilitators.count))").tag("Facilitators")
                }
                .pickerStyle(.segmented)
                .padding(16)

                SearchBar(text: $searchText, placeholder: "Search by name or email...")
                    .padding(.bottom, 8)

                if selectedTab == "Students" {
                    if filteredStudents.isEmpty {
                        EmptyStateView(
                            icon: "person.slash",
                            title: "No Students",
                            message: searchText.isEmpty ? "Add your first student" : "No students match your search"
                        )
                    } else {
                        List {
                            ForEach(filteredStudents) { student in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(student.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(PortfolioTheme.navy)
                                        Text(student.email)
                                            .font(.system(size: 13))
                                            .foregroundStyle(PortfolioTheme.subtitleGray)
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingUser = ("student", student)
                                    showingEditUser = true
                                }
                            }
                            .onDelete { offsets in
                                let student = filteredStudents[offsets.first!]
                                userToDelete = ("student", student)
                                showDeleteConfirmation = true
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                } else {
                    if filteredFacilitators.isEmpty {
                        EmptyStateView(
                            icon: "person.slash",
                            title: "No Facilitators",
                            message: searchText.isEmpty ? "Add your first facilitator" : "No facilitators match your search"
                        )
                    } else {
                        List {
                            ForEach(filteredFacilitators) { facilitator in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(facilitator.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(PortfolioTheme.navy)
                                        Text(facilitator.email)
                                            .font(.system(size: 13))
                                            .foregroundStyle(PortfolioTheme.subtitleGray)
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingUser = ("facilitator", facilitator)
                                    showingEditUser = true
                                }
                            }
                            .onDelete { offsets in
                                let facilitator = filteredFacilitators[offsets.first!]
                                userToDelete = ("facilitator", facilitator)
                                showDeleteConfirmation = true
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .navigationTitle("Manage Users")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingAddUser = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(PortfolioTheme.teal)
                    }

                    Button("Done") { dismiss() }
                }
            }
            .alert("Delete \(selectedTab == "Students" ? "Student" : "Facilitator")?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let userToDelete = userToDelete {
                        if userToDelete.type == "student", let student = userToDelete.user as? Student {
                            students.removeAll { $0.id == student.id }
                        } else if userToDelete.type == "facilitator", let facilitator = userToDelete.user as? Facilitator {
                            facilitators.removeAll { $0.id == facilitator.id }
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                if let userToDelete = userToDelete {
                    if let student = userToDelete.user as? Student {
                        Text("Are you sure you want to delete \(student.name)? This action cannot be undone.")
                    } else if let facilitator = userToDelete.user as? Facilitator {
                        Text("Are you sure you want to delete \(facilitator.name)? This action cannot be undone.")
                    }
                }
            }
            .sheet(isPresented: $showingAddUser) {
                AddUserView(
                    userType: selectedTab,
                    onAdd: { name, email in
                        if selectedTab == "Students" {
                            students.append(Student(name: name, email: email))
                        } else {
                            facilitators.append(Facilitator(name: name, email: email))
                        }
                    }
                )
            }
            .sheet(isPresented: $showingEditUser) {
                if let editingUser = editingUser {
                    if editingUser.type == "student", let student = editingUser.user as? Student {
                        EditUserView(
                            userType: "Student",
                            name: student.name,
                            email: student.email,
                            onSave: { newName, newEmail in
                                if let index = students.firstIndex(where: { $0.id == student.id }) {
                                    students[index].name = newName
                                    students[index].email = newEmail
                                }
                            }
                        )
                    } else if editingUser.type == "facilitator", let facilitator = editingUser.user as? Facilitator {
                        EditUserView(
                            userType: "Facilitator",
                            name: facilitator.name,
                            email: facilitator.email,
                            onSave: { newName, newEmail in
                                if let index = facilitators.firstIndex(where: { $0.id == facilitator.id }) {
                                    facilitators[index].name = newName
                                    facilitators[index].email = newEmail
                                }
                            }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Add User View

struct AddUserView: View {
    let userType: String
    let onAdd: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("User Details") {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
            }
            .navigationTitle("Add \(userType)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(
                            name.trimmingCharacters(in: .whitespacesAndNewlines),
                            email.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

// MARK: - Edit User View

struct EditUserView: View {
    let userType: String
    @State private var name: String
    @State private var email: String
    let onSave: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss

    init(userType: String, name: String, email: String, onSave: @escaping (String, String) -> Void) {
        self.userType = userType
        self.onSave = onSave
        _name = State(initialValue: name)
        _email = State(initialValue: email)
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("User Details") {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
            }
            .navigationTitle("Edit \(userType)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(
                            name.trimmingCharacters(in: .whitespacesAndNewlines),
                            email.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}
