//
//  HelpView.swift
//  Shh
//
//  Created by Jia Jang on 11/19/24.
//

import SwiftUI

enum HelpRow: CaseIterable {
    case meteringMethod
    case levels
    case maxNoise
    case pushNotification
    case dangerStandard
}

extension HelpRow {
    var systemName: String {
        switch self {
        case .meteringMethod: "waveform.badge.microphone"
        case .levels: "ring.circle"
        case .maxNoise: "speaker.wave.2.fill"
        case .pushNotification: "bell.badge.fill"
        case .dangerStandard: "exclamationmark.triangle.fill"
        }
    }
    
    var boxColor: Color {
        switch self {
        case .meteringMethod: .accent
        case .levels: .accent
        case .maxNoise: .accent
        case .pushNotification: .pink
        case .dangerStandard: .pink
        }
    }
    
    var title: String {
        switch self {
        case .meteringMethod: "어떻게 측정하나요?"
        case .levels: "소음 단계는 어떻게 되나요?"
        case .maxNoise: "최대 소음이 뭔가요?"
        case .pushNotification: "알림은 언제 오나요?"
        case .dangerStandard: "언제 ‘위험’이 되나요?"
        }
    }
    
    var description: String {
        switch self {
        case .meteringMethod: "기기 마이크를 사용해서 실시간으로 소음 수준을 확인하며, 배경 소음에 비해서 얼만큼 크게 들리는지 계산해요."
        case .levels: "소음 단계는 양호와 위험 두 단계로 이루어져 있어요. 양호일 땐 녹색, 위험일 땐 분홍색으로 소음 단계를 볼 수 있어요."
        case .maxNoise: "‘양호’ 수준을 유지하면서 낼 수 있는 소리의 최대 크기예요. 이 이상 큰 소리를 내면 시끄럽다고 느낄 수 있어요."
        case .pushNotification: "소음 단계가 ‘위험’이 되었을 때, 알림이 와요. 또한 ‘위험’이 지속될 경우, 20초마다 알림을 보내요."
        case .dangerStandard: "2초 동안 ‘소음'이 지속될 경우 혹은 지나치게 큰 소리가 감지되었을 때, 소음 단계가 ‘위험'이 돼요."
        }
    }
}

struct HelpRowView: View {
    // MARK: Properties
    let row: HelpRow
    
    // MARK: Body
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(row.boxColor)
                
                Image(systemName: row.systemName)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            .frame(width: 90, height: 90)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(row.title)
                    .foregroundStyle(.white)
                
                Text(row.description)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .bold()
            .padding(.trailing, 20)
            .frame(maxWidth: 260)
        }
    }
}

struct HelpView: View {
    // MARK: Properties
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
          // action
        } label: {
            ZStack {
                Circle()
                    .fill(.customBlack)
                    .frame(width: 30)
                
                Image(systemName: "xmark")
                    .foregroundStyle(.gray2)
                    .font(.callout)
            }
            .padding(.trailing, 20)
        }
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
    
    private var helpRows: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                
                ForEach(HelpRow.allCases, id: \.self) { row in
                    HelpRowView(row: row)
                }
            }
        }
    }
}

#Preview {
    HelpView()
}
