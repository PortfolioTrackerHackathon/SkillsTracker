//
//  Employer.swift
//  SkillsandPortfolioTracker
//  Created by wadzie on 4/9/2026.
//
import SwiftUI

struct Employer: View {
    var body : some View{
        NavigationStack{
            ScrollView{
                HStack{
                    Image("Student photo")
                        .resizable()
                        .frame(width:100, height: 100)
                    Spacer()
                    
                    VStack{
                        Text("Candidate profile")
                            .padding(10)
                            .fontWeight(.bold)
                        Text("Tendai Moyo")
                            .fontWeight(.bold)
                            .font(.title)
                        Text("MCRI.Software development")
                            .foregroundColor(.gray)
                        Text("8 skills demonstrated.14 verified evidence items")
                            .foregroundColor(.gray)
                        
                    }
                    .padding(10)
                    Spacer()
                }
                HStack {
                    CircularProgressView(progress: 0.78)
                        .padding(10)
                    VStack{
                        Text("Strong Progress!")
                            .bold()
                        Text("Tendai has demonstrated solid and a commitment to continuos growth")
                            .padding(4)
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:180, height: 15)
                                .foregroundColor(.teal)
                                .padding(3)
                            Text("78 %")
                        }
                    }
                    
                }
                .padding(20)
                VStack {
                    Text("Technical skills")
                        .bold()
                        .padding(10)
                    NavigationStack{
                        HStack{
                            Image(systemName: "arrow.2.circlepath")
                                .padding(5)
                            Text("Loops")
                            Spacer()
                            NavigationLink("Demonstrated >"){
                                
                                Loop()
                            }
                            .padding(5)
                        }
                        HStack {
                            Image(systemName:"function")
                                .padding(5)
                            Text("Functions")
                            Spacer()
                            NavigationLink("Demonstrated >"){
                               Functions()
                            }
                            .padding(5)
                        }
                        HStack{
                            Image(systemName:"arrow.triangle.branch")
                                .padding(5)
                            Text("Git & GitHub")
                            Spacer()
                            NavigationLink("Intermediate >"){
                                Git()
                            }
                            .padding(5)
                        }
                        
                        
                    }
                }
                
                VStack{
                    Text("Essential Skills")
                        .bold()
                        .padding(10)
                    NavigationStack{
                        HStack{
                            Image(systemName: "")
                                .padding(5)
                            Text("Communication")
                            Spacer()
                            NavigationLink("Advanced >"){
                              Communication()
                            }
                            .padding(5)
                        }
                        HStack {
                            Image(systemName: "")
                                .padding(5)
                            Text("Teamwork ")
                            Spacer()
                            NavigationLink("In progress >"){
                               Teamwork()
                            }
                            .padding(5)
                        }
                    }
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundStyle(.teal)
//                        Text("Share profile")
//                            .foregroundColor(.white)
                  //  Button("Share profile", action: <#T##() -> Void#>){
                        
                 //9    }
                    Text("Profile visibility: Anywhere with link")
                    Spacer()
                    HStack{
                        Text("Home")
                            .padding(10)
                        Text("My portfolio")
                            .padding(10)
                        VStack{
                            Image(systemName: "person.fill")
                            Text("Profile")
                                .padding(10)
                        }
                        Text("Settings")
                    }
                }
                .padding(.leading,10)
            }
            
        }
        
    }
    
}

#Preview {
    Employer()
}



//
//import SwiftUI
//
//struct Employer: View {
//    var body: some View{
//        
//    }
//}
//#Preview {
//    Employer()
//}
