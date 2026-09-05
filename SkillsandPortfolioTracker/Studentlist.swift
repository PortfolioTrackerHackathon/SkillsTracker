//
//  Studentlist.swift
//  SkillsandPortfolioTracker
//
//  Created by Sebastian on 5/9/2026.
//

import SwiftUI

struct Studentlist: View {
    var body: some View {
        List(demoStudentNames, id: \.self) { name in
            NavigationLink(destination: HomeView(userName: name)) {
                HStack {
                    Text(name)
                    Spacer()
                    Image(systemName: "person.fill")
                }
            }
        }
        .navigationTitle("Students")
    }
}

#Preview {
    NavigationStack {
        Studentlist()
    }
}
