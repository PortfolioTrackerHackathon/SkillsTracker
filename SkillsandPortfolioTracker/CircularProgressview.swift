//
//  CircularProgressview.swift
//  SkillsandPortfolioTracker
//
//  Created by NYAMAYARO TAKUDZWA on 5/9/2026.
//
import SwiftUI

struct CircularProgressView: View {
    var progress: Double // 0.0 to 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // start at top, not right side
                .animation(.easeInOut(duration: 0.4), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.headline)
            Text("Overall progress")
                .font(.system(size: 9, weight: .regular, design: .rounded))
                .offset(x: 0, y: 14)
        }
        .frame(width: 100, height: 100)
    }
    
}


#Preview {
    CircularProgressView(progress: 0.78)
}
