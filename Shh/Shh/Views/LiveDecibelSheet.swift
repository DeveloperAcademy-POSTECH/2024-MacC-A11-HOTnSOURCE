//
//  LiveDecibelSheet.swift
//  Shh
//
//  Created by sseungwonnn on 11/19/24.
//

import SwiftUI

// MARK: - 실시간 현황 시트
struct LiveDecibelSheet: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            VStack {
                decibelInfo
                    .frame(height: geometry.size.height * 1 / 5)
                    .padding(.leading)
                
                LiveDecibelChart(
                    frameWidth: geometry.size.width,
                    frameHeight: geometry.size.height * 3 / 5)
                    .frame(height: geometry.size.height * 3 / 5)
                
                userDecibel
                    .frame(height: geometry.size.height * 1 / 5) // 세 높이의 합은 1(= 1/5 + 3/5 + 1/5)
            }
            .padding(.vertical, 5)
            .background(.customBlack)
            .accessibilityHint("실시간으로 소음 상태를 나타냅니다. 반복해서 탭하면 바뀌는 데시벨 값을 실시간으로 확인할 수 있습니다.")
        }
    }
    
    // MARK: subViews
    private var decibelInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("배경 소음 | \(Int(audioManager.backgroundDecibel.rounded())) dB")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray2)
                .accessibilityLabel("배경 소음 \(Int(audioManager.backgroundDecibel.rounded())) 데시벨")
            
            Text("최대 소음 | \(audioManager.maximumDecibel) dB")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray2)
                .accessibilityLabel("최대 소음 \(audioManager.maximumDecibel) 데시벨")
            
            Text("소음 정보는 계산에만 활용되고 저장되지 않습니다.")
                .font(.caption2)
                .fontWeight(.regular)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var decibelInfoForSE: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("배경 소음 | \(Int(audioManager.backgroundDecibel.rounded())) dB")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray2)
                .accessibilityLabel("배경 소음 \(Int(audioManager.backgroundDecibel.rounded())) 데시벨")
            
            Text("최대 소음 | \(audioManager.maximumDecibel) dB")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray2)
                .accessibilityLabel("최대 소음 \(audioManager.maximumDecibel) 데시벨")
            
            Text("소음 정보는 계산에만 활용되고 저장되지 않습니다.")
                .font(.caption2)
                .fontWeight(.regular)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var userDecibel: some View {
        HStack {
            Text("\(Int(audioManager.userDecibel.rounded()))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            + Text(" dB")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .accessibilityLabel("현재 \(Int(audioManager.userDecibel.rounded())) 데시벨입니다.")
    }
}

// MARK: - 중앙의 실시간 차트
struct LiveDecibelChart: View {
    // MARK: properties
    @EnvironmentObject var audioManager: AudioManager

    let frameWidth: CGFloat
    let frameHeight: CGFloat
    private let barWidth: CGFloat = 4
    private let barSpacing: CGFloat = 6
    
    // MARK: body
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            maximumDecibelRectangle
                .frame(height: frameHeight / 2) // 1/2 크기; 최대 소음에 해당하는 라인
            
            standardBar
                .frame(height: frameHeight) // 전체 크기; 최대 소음 * 2에 해당하는 라인
            
            decibelBars
                .frame(height: frameHeight) // 전체 크기
        }
    }
    
    // MARK: subViews
    private var maximumDecibelRectangle: some View {
        Rectangle()
            .fill(.gray.opacity(0.1))
            .frame(maxWidth: .infinity)
    }
    
    private var standardBar: some View {
        VStack(alignment: .center, spacing: 0) {
            Circle()
                .fill(.gray2)
                .frame(width: 12, height: 12)
            
            Rectangle()
                .fill(.gray2)
                .frame(width: 2, height: frameHeight)
                .offset(x: 0, y: -6)
            
            Circle()
                .fill(.gray2)
                .frame(width: 12, height: 12)
                .offset(x: 0, y: -12)
        }
    }
    
    private var decibelBars: some View {
        HStack(spacing: barSpacing) {
            // 실제 데시벨 막대
            ForEach(audioManager.userDecibelBuffer, id: \.self) { decibel in
                RoundedRectangle(cornerRadius: 100)
                    .fill(Int(decibel) > audioManager.maximumDecibel ? .pink : .green)
                    .frame(width: barWidth, height: decibelRowHeight(decibel: decibel))
            }
            
            // 반대편에 보이지 않는 막대
            ForEach(audioManager.userDecibelBuffer.indices, id: \.self) { index in
                if index != 0 { // 안 보이는 막대들의 개수는 (전체 - 1)개
                    Rectangle()
                        .fill(.clear)
                        .frame(width: barWidth)
                }
            }
        }
        .clipShape(Rectangle())
        .frame(width: frameWidth)
    }

    // MARK: actionHandler
    /// 화면 비율에 맞게끔 높이를 조정합니다.
    private func decibelRowHeight(decibel: Float) -> CGFloat {
        min(frameHeight * CGFloat(decibel) / CGFloat(audioManager.maximumDecibel * 2), frameHeight) // 최대 소음 * 2를 넘지 않게
    }
}

#Preview {
    @Previewable @StateObject var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    LiveDecibelSheet()
        .environmentObject(audioManager)
}
