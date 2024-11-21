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
        VStack {
            closeButton
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            VStack {
                introduce
                
                segmentedPicker
                
                switch selectedHelpType {
                case .guide:
                    guideRows
                case .soundTable:
                    soundTable
                }
            }
            .background(.customBlack)
        }
        .background(.accent)
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
        .padding(.trailing, 20)
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
                Text("궁금할 만한 정보를 알아보세요")
            }
            .font(.callout)
            
            Spacer().frame(height: 20)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(backgroundGradient)
    }
    
    private var segmentedPicker: some View {
        Picker("", selection: $selectedHelpType) {
            ForEach(HelpType.allCases, id: \.self) { type in
                Text(type.title)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var guideRows: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                
                ForEach(GuideRowItem.allCases, id: \.self) { row in
                    GuideRow(row: row)
                }
                
                Spacer()
            }
        }
    }
    
    private var soundTable: some View {
        List {
            ForEach(SoundTableItem.backgroundDecibelOptions, id: \.self) { decibel in
                HStack(spacing: 20) {
                    Text("~\(Int(decibel)) dB")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Text(SoundTableItem.decibelWriting(decibel: decibel))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
            }
        }
        .fontWeight(.bold)
        .scrollContentBackground(.hidden)
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

// MARK: - 소리 기준표 각 항목
final class SoundTableItem {
    static let backgroundDecibelOptions: [Float] = [30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0]
    
    /// 해당 데시벨에 대한 설명입니다. 이를 통해 사용자가 데시벨 정도를 가늠할 수 있습니다.
    static func decibelWriting(decibel: Float) -> LocalizedStringKey {
        let intDecibel = Int(decibel)
        
        switch intDecibel {
        case 30:
            return "아주 조용한 방에서의 주변 소리"
        case 35:
            return "냉장고, 바람 소리가 들리는 정도의 실내 소음"
        case 40:
            return "조용한 카페에서 나오는 배경 소음"
        case 45:
            return "주택가에서 들리는 적당한 실내 소음"
        case 50:
            return "조용한 사무실에서 들리는 일반적인 실내 소음"
        case 55:
            return "평소 대화 소리나 가정에서의 일상 소음"
        case 60:
            return "일상적인 대화 소리, 도로에서의 자동차 소음"
        case 65:
            return "시끄러운 사무실이나 사람들 간의 활발한 토론 소리"
        case 70:
            return "도로변에서 들리는 자동차와 사람들 소리"
        case 0:
            return ""
        default:
            return "데시벨 설명 없음"
        }
    }
}

#Preview {
    HelpView()
}
