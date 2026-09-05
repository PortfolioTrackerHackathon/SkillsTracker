//
//  Studentlist.swift
//  SkillsandPortfolioTracker
//
//  Created by Sebastian on 5/9/2026.
//

import SwiftUI

struct Student: Identifiable {
    
    let id = UUID()
    let name: String
    
}

let students = [
    Student(name: "Sebastian"),
    Student(name: "Wadzanayi"),
    Student(name: "Bongani"),
    Student(name: "Takudzwa"),
    Student(name: "Octavia"),
    Student(name: "Benard"),
    Student(name: "Audery"),
    Student(name: "Valerie"),
    Student(name: "Chapo"),
    Student(name: "Mthusi"),
]

struct Home: View {
    
    var body: some View {
        
        Spacer()
        
        NavigationStack {
            
            List {
                
                NavigationLink(destination:  HomeView(userName: demoStudents[0])) {
                    HStack {
                        Text("Sebastian")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                
                NavigationLink(destination: HomeView(userName: demoStudents[1])) {
                    HStack {
                        Text("Wadzanayi")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                
                NavigationLink(destination:  HomeView(userName: demoStudents[2])) {
                    HStack {
                        Text("Bongani")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                
                NavigationLink(destination:  HomeView(userName: demoStudents[3])) {
                    HStack {
                        Text("Takudzwa")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                
                NavigationLink(destination:  HomeView(userName: demoStudents[4])) {
                    HStack {
                        Text("Octavia")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                
                NavigationLink(destination:  HomeView(userName: demoStudents[5])) {
                    HStack {
                        Text("Benard")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                NavigationLink(destination:  HomeView(userName: demoStudents[6])) {
                    HStack {
                        Text("Audery")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                NavigationLink(destination:  HomeView(userName: demoStudents[7])) {
                    HStack {
                        Text("Valerie")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                NavigationLink(destination:  HomeView(userName: demoStudents[8])) {
                    HStack {
                        Text("Chapo")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
                NavigationLink(destination:  HomeView(userName: demoStudents[9])) {
                    HStack {
                        Text("Mthusi")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                }
            }
            .navigationTitle("Students")
        }
    }
}

#Preview {
    Home()
}
