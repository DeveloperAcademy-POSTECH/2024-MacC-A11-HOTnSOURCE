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
                    helpRows
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
                .accessibilityLabel("반짝이는 전구")
            
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
    
    private var helpRows: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                
                ForEach(HelpRowItem.allCases, id: \.self) { row in
                    HelpRow(row: row)
                }
            }
        }
    }
}

// MARK: - 도움말 하나 하나
struct HelpRow: View {
    // MARK: Properties
    let row: HelpRowItem
    
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
                    .accessibilityLabel(row.accessibilityLabel)
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

#Preview {
    HelpView()
}
