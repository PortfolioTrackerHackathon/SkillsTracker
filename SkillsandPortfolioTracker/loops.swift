//
//  loops.swift
//  SkillsandPortfolioTracker
//
//  Created by NYAMAYARO TAKUDZWA on 5/9/2026.
//
import SwiftUI

struct Loop: View {
    var body : some View{
        VStack{
            Text("Loops")
                .bold()
                .font(.largeTitle)
            Image("loop")
                .resizable()
                .frame(width:360, height: 400)
        }
    }
    
}

#Preview(){
    Loop()
}
