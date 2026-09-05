//
//  Student.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 4/9/2026.
//

import SwiftUI

// Custom teal color for iOS 13 compatibility
extension Color {
    static let customTeal = Color(red: 0.0, green: 0.5, blue: 0.5)
}

struct Student: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Photo and caption state
    @State private var showPhotoPicker = false
    @State private var selectedSkill = ""
    @State private var selectedImage: UIImage? = nil
    @State private var caption = ""
    @State private var showCaptionSheet = false
    
    // Link state for Git & GitHub
    @State private var showLinkSheet = false
    @State private var gitLink = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    alertMessage = "Go back to previous screen"
                    showAlert = true
                }) {
                    Image(systemName: "arrow.left")
                        .font(.body)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Candidate profile")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    alertMessage = "Share profile via..."
                    showAlert = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Candidate Info Section
                    HStack(spacing: 15) {
                        // Profile Image
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 70, height: 70)
                            Image(systemName: "person.fill")
                                .font(.system(size: 35))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bongani")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("MCRI learner · Software development")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("8 skills demonstrated · 14 verified evidence items")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Overall Progress Section
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            // Circular Progress
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                                    .frame(width: 100, height: 100)
                                
                                Circle()
                                    .trim(from: 0, to: 0.78)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.customTeal, Color.customTeal.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .frame(width: 100, height: 100)
                                    .rotationEffect(.degrees(-90))
                                
                                VStack {
                                    Text("78%")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Overall progress")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Strong progress!")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("Tendai has demonstrated solid skills and a commitment to continuous growth.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(3)
                                
                                // Progress Bar
                                VStack(alignment: .leading, spacing: 4) {
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 8)
                                            Rectangle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color.customTeal, Color.green],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geometry.size.width * 0.78, height: 8)
                                        }
                                    }
                                    .frame(height: 8)
                                    
                                    Text("78%")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Skills Section
                    VStack(alignment: .leading, spacing: 15) {
                        // Technical Skills
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Technical skills")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            SkillRow(icon: "arrow.triangle.2.circlepath", name: "Loops", status: "Demonstrated", onTap: {
                                selectedSkill = "Loops"
                                showPhotoPicker = true
                            })
                            SkillRow(icon: "function", name: "Functions", status: "Demonstrated", onTap: {
                                selectedSkill = "Functions"
                                showPhotoPicker = true
                            })
                            SkillRow(icon: "arrow.triangle.branch", name: "Git & GitHub", status: "Intermediate", onTap: {
                                showLinkSheet = true
                            })
                        }
                        
                        // Essential Skills
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Essential skills")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            SkillRow(icon: "bubble.left.and.bubble.right", name: "Communication", status: "Advanced", onTap: {
                                selectedSkill = "Communication"
                                showPhotoPicker = true
                            })
                            SkillRow(icon: "person.2.fill", name: "Teamwork", status: "In Progress", onTap: {
                                selectedSkill = "Teamwork"
                                showPhotoPicker = true
                            })
                        }
                    }
                    .padding(.horizontal)
                    
                    // Featured Evidence Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Evidence")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        // Evidence Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.customTeal.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                                        .font(.body)
                                        .foregroundColor(.customTeal)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Number Guessing Game")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text("A Python-based console game with loops, conditionals and user input.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                            }
                            
                            HStack {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Verified")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    alertMessage = "View Number Guessing Game evidence"
                                    showAlert = true
                                }) {
                                    Text("View evidence")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.customTeal)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Share Profile Section
                    VStack(spacing: 12) {
                        Button(action: {
                            alertMessage = "Share profile link copied to clipboard"
                            showAlert = true
                        }) {
                            Text("Share profile")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.customTeal)
                                .cornerRadius(12)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "link")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Profile visibility: Anywhere with link")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            
            // Bottom Navigation Bar
            HStack {
                NavigationItem(icon: "house.fill", label: "Home", isActive: false, onTap: {
                    alertMessage = "Navigate to Home"
                    showAlert = true
                })
                NavigationItem(icon: "briefcase.fill", label: "My portfolio", isActive: false, onTap: {
                    alertMessage = "Navigate to My portfolio"
                    showAlert = true
                })
                NavigationItem(icon: "person.fill", label: "Profile", isActive: true, onTap: {
                    alertMessage = "Already on Profile"
                    showAlert = true
                })
                NavigationItem(icon: "gearshape.fill", label: "Settings", isActive: false, onTap: {
                    alertMessage = "Navigate to Settings"
                    showAlert = true
                })
            }
            .padding()
            .background(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
        }
        .background(Color.gray.opacity(0.05))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Action"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showPhotoPicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary, onImageSelected: {
                showCaptionSheet = true
            }, onCancel: {
                // Sheet will be dismissed automatically
            })
        }
        .sheet(isPresented: $showCaptionSheet) {
            CaptionSheet(selectedImage: selectedImage, caption: $caption, skillName: selectedSkill, onSave: {
                showCaptionSheet = false
                selectedImage = nil
                caption = ""
                alertMessage = "Photo and caption saved for \(selectedSkill)"
                showAlert = true
            }, onCancel: {
                showCaptionSheet = false
                selectedImage = nil
                caption = ""
            })
        }
        .sheet(isPresented: $showLinkSheet) {
            LinkSheet(link: $gitLink, onSave: {
                showLinkSheet = false
                alertMessage = "Git & GitHub link saved: \(gitLink)"
                showAlert = true
            }, onCancel: {
                showLinkSheet = false
            })
        }
    }
}

struct SkillRow: View {
    let icon: String
    let name: String
    let status: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(.customTeal)
                    .frame(width: 30)
                
                Text(name)
                    .font(.subheadline)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text(status)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NavigationItem: View {
    let icon: String
    let label: String
    let isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(isActive ? .customTeal : .gray)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(isActive ? .customTeal : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    Student()
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var onImageSelected: () -> Void
    var onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImageSelected()
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
            picker.dismiss(animated: true)
        }
    }
}

// Caption Sheet
struct CaptionSheet: View {
    @Environment(\.presentationMode) var presentationMode
    let selectedImage: UIImage?
    @Binding var caption: String
    let skillName: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                        .padding()
                }
                
                VStack(alignment: .leading) {
                    Text("Add caption for \(skillName):")
                        .font(.headline)
                    TextField("Write a short note about this...", text: $caption)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical)
                }
                .padding()
                
                Spacer()
                
                Button(action: onSave) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.customTeal)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Add Photo")
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                }
            )
        }
    }
}

// Link Sheet
struct LinkSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var link: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Add Git & GitHub Repository Link:")
                        .font(.headline)
                    TextField("https://github.com/username/repo", text: $link)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                .padding()
                
                Spacer()
                
                Button(action: onSave) {
                    Text("Save Link")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.customTeal)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Add Repository Link")
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                }
            )
        }
    }
}

