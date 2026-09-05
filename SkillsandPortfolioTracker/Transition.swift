//
//  Signup.swift
//  SkillsandPortfolioTracker
//
//  Created by wadzie on 5/9/2026.
//
import SwiftUI

// MARK: - Design tokens

enum MCRIColor {
    static let navy      = Color(red: 0.055, green: 0.165, blue: 0.278)  // #0E2A47
    static let navy2     = Color(red: 0.071, green: 0.200, blue: 0.353)  // #12335A
    static let teal       = Color(red: 0.180, green: 0.749, blue: 0.647) // #2EBFA5
    static let tealDark  = Color(red: 0.106, green: 0.561, blue: 0.482) // #1B8F7B
    static let mint       = Color(red: 0.906, green: 0.961, blue: 0.945) // #E7F5F1
    static let gold       = Color(red: 0.953, green: 0.725, blue: 0.231) // #F3B93B
    static let muted      = Color(red: 0.486, green: 0.541, blue: 0.604) // #7C8A9A
}

// MARK: - Page model

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let tagline: String
    let featureIconName: String
    let featureIconBackground: Color
    let featureIconForeground: Color
    let featureTitle: String
    let featureSubtitle: String
}

private let onboardingPages: [OnboardingPage] = [
    OnboardingPage(
        title: "MCRI Skills\nPortfolio",
        tagline: "Show what you can do",
        featureIconName: "person.2.fill",
        featureIconBackground: MCRIColor.mint,
        featureIconForeground: MCRIColor.tealDark,
        featureTitle: "Share your progress",
        featureSubtitle: "Share your portfolio with confidence."
    ),
    OnboardingPage(
        title: "MCRI Skills\nPortfolio",
        tagline: "Show what you can do",
        featureIconName: "doc.text.fill",
        featureIconBackground: Color(red: 0.984, green: 0.941, blue: 0.863), // cream
        featureIconForeground: MCRIColor.gold,
        featureTitle: "Add evidence",
        featureSubtitle: "Upload and organize proof of your work."
    ),
    OnboardingPage(
        title: "MCRI Skills\nPortfolio",
        tagline: "Show what you can do",
        featureIconName: "person.2.fill",
        featureIconBackground: MCRIColor.mint,
        featureIconForeground: MCRIColor.tealDark,
        featureTitle: "Share your progress",
        featureSubtitle: "Share your portfolio with confidence."
    )
]

// MARK: - Root onboarding view

struct MCRIOnboardingView: View {
    @State private var currentPage = 0
    @Namespace private var featureRowNamespace

    var body: some View {
        VStack(spacing: 0) {

            // Slides — TabView gives us the native swipe + slide animation for free.
            TabView(selection: $currentPage) {
                ForEach(Array(onboardingPages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.45), value: currentPage)

            OnboardingFooter(
                currentPage: $currentPage,
                pageCount: onboardingPages.count
            )
        }
        .background(Color.white)
    }
}

// MARK: - Single slide

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Logo mark
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(MCRIColor.navy)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "chevron.up.chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(MCRIColor.teal)
                )
                .padding(.bottom, 22)

            Text(page.title)
                .font(.system(size: 32, weight: .heavy, design: .default))
                .foregroundColor(MCRIColor.navy)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 10)

            Text(page.tagline)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(MCRIColor.tealDark)
                .padding(.bottom, 14)

            IllustrationView()
                .frame(height: 220)
                .padding(.top, 6)

            Spacer(minLength: 24)

            FeatureRow(page: page)
                .padding(.bottom, 8)
        }
        .padding(.horizontal, 28)
        .padding(.top, 24)
    }
}

// MARK: - Feature row (animates in each time its slide becomes active)

private struct FeatureRow: View {
    let page: OnboardingPage
    @State private var appeared = false

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .fill(page.featureIconBackground)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: page.featureIconName)
                        .foregroundColor(page.featureIconForeground)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(page.featureTitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(MCRIColor.navy)
                Text(page.featureSubtitle)
                    .font(.system(size: 14))
                    .foregroundColor(MCRIColor.muted)
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 10)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
                appeared = true
            }
        }
    }
}

// MARK: - Illustration (simple vector placeholder built from SF Symbols/shapes)

private struct IllustrationView: View {
    var body: some View {
        ZStack {
            Ellipse()
                .fill(MCRIColor.mint)
                .padding(10)

            HStack(spacing: 20) {
                VStack {
                    Circle()
                        .fill(Color(red: 0.961, green: 0.780, blue: 0.604))
                        .frame(width: 60, height: 60)
                    RoundedRectangle(cornerRadius: 18)
                        .fill(MCRIColor.teal)
                        .frame(width: 70, height: 80)
                }

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.851, green: 0.894, blue: 0.925))
                    .frame(width: 90, height: 55)
                    .overlay(
                        HStack(spacing: 6) {
                            Circle()
                                .fill(MCRIColor.teal)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            VStack(alignment: .leading, spacing: 4) {
                                Capsule().fill(Color(red: 0.725, green: 0.776, blue: 0.816)).frame(width: 40, height: 6)
                                Capsule().fill(Color(red: 0.725, green: 0.776, blue: 0.816)).frame(width: 30, height: 6)
                            }
                        }
                    )

                VStack {
                    Circle()
                        .fill(Color(red: 0.906, green: 0.647, blue: 0.420))
                        .frame(width: 56, height: 56)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(MCRIColor.navy2)
                        .frame(width: 64, height: 70)
                }
            }

            VStack {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 14)
                        .fill(MCRIColor.navy2)
                        .frame(width: 170, height: 110)
                        .overlay(
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Circle().fill(MCRIColor.gold).frame(width: 6, height: 6)
                                    Circle().fill(MCRIColor.teal).frame(width: 6, height: 6)
                                }
                                Capsule().fill(Color.white.opacity(0.85)).frame(width: 110, height: 6)
                                Capsule().fill(Color.white.opacity(0.5)).frame(width: 130, height: 6)
                                Capsule().fill(Color.white.opacity(0.85)).frame(width: 90, height: 6)
                                Capsule().fill(MCRIColor.gold.opacity(0.8)).frame(width: 120, height: 6)
                            }
                            .padding(14),
                            alignment: .topLeading
                        )
                        .overlay(
                            Circle()
                                .fill(MCRIColor.teal)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "chevron.left.slash.chevron.right")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 12, y: -50),
                            alignment: .topTrailing
                        )
                }
                Spacer()
            }
        }
    }
}

// MARK: - Footer: dots + Skip / Next controls

private struct OnboardingFooter: View {
    @Binding var currentPage: Int
    let pageCount: Int

    private var isLastPage: Bool { currentPage == pageCount - 1 }

    var body: some View {
        VStack(spacing: 20) {
            // Dots
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Capsule()
                        .fill(index == currentPage ? MCRIColor.teal : Color(red: 0.843, green: 0.871, blue: 0.902))
                        .frame(width: index == currentPage ? 22 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.35), value: currentPage)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.45)) {
                                currentPage = index
                            }
                        }
                }
            }

            HStack {
                Button("Skip") {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        currentPage = pageCount - 1
                    }
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(MCRIColor.muted)
                .opacity(isLastPage ? 0 : 1)
                .disabled(isLastPage)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        if isLastPage {
                            currentPage = 0 // or trigger dismissal / navigation to the app
                        } else {
                            currentPage += 1
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(isLastPage ? "Get started" : "Next")
                            .font(.system(size: 15, weight: .bold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 14)
                    .background(
                        Capsule().fill(isLastPage ? MCRIColor.tealDark : MCRIColor.navy)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 34)
        .padding(.top, 12)
    }
}

// MARK: - Preview

struct MCRIOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        MCRIOnboardingView()
    }
}
