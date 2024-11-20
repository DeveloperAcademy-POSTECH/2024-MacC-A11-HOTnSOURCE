//
//  HelpView.swift
//  Shh
//
//  Created by Jia Jang on 11/19/24.
//

import SwiftUI

struct HelpView: View {
    // MARK: Properties
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedHelpType: HelpType = .guide
    
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [.accent, .customBlack]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.accent
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    closeButton
                }
                
                VStack {
                    introduce
                    
                    Picker("", selection: $selectedHelpType) {
                        ForEach(HelpType.allCases, id: \.self) { type in
                            Text(type.title)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    switch selectedHelpType {
                    case .guide:
                        guideRows
                    case .soundTable:
                        soundTable
                    }
                }
                .background(.customBlack)
            }
        }
    }
    
    // MARK: Subviews
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.gray2)
                .font(.callout)
                .padding(6)
                .background {
                    Circle()
                        .fill(.customBlack)
                }
        }
        .padding([.trailing], 20)
    }
    
    private var introduce: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 10)

            Image(systemName: "lightbulb.max.fill")
                .font(.system(size: 48))
            
            Text("Shh-! 측정 도움말")
                .font(.title)
                .bold()
            
            VStack {
                Text("측정 기준부터 알림까지")
                Text("궁금할만한 정보를 알아보세요")
            }
            .font(.callout)
            
            Spacer().frame(height: 20)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(backgroundGradient)
    }
    
    private var guideRows: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                
                ForEach(GuideRowItem.allCases, id: \.self) { row in
                    GuideRow(row: row)
                }
            }
        }
    }
    
    private var soundTable: some View {
        Text("sound table")
    }
}

// MARK: - 도움말 하나 하나
struct GuideRow: View {
    // MARK: Properties
    let row: GuideRowItem
    
    // MARK: Body
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(row.boxColor)
                    .frame(width: 80, height: 80)
                
                Image(systemName: row.systemName)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(row.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Text(row.description)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

// MARK: - 도움말 종류
enum HelpType: CaseIterable {
    case guide
    case soundTable
}

extension HelpType {
    var title: LocalizedStringKey {
        switch self {
        case .guide:
            return "기본 정보"
        case .soundTable:
            return "소리 기준표"
        }
    }
}

#Preview {
    HelpView()
}
