//
//  LiveDecibelSheet.swift
//  Shh
//
//  Created by sseungwonnn on 11/19/24.
//

import SwiftUI

struct LiveDecibelSheet: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            VStack {
                decibelInfo
                    .frame(height: geometry.size.height * 3 / 15) // 1/6
                    .padding(.leading)
                
                LiveDecibelChart(frameWidth: geometry.size.width, frameHeight: geometry.size.height * 2 / 3)
                    .frame(height: geometry.size.height * 2 / 3) // 2/3
                
                userDecibel
                    .frame(height: geometry.size.height * 2 / 15) // 1/6; 세 개의 합은 1
            }
            .padding(.vertical, 5)
            .background(.customBlack)
            
        }
    }
    
    // MARK: subViews
    private var decibelInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("배경 소음 | \(Int(audioManager.backgroundDecibel.rounded())) dB")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray2)
            Text("최대 소음 | \(audioManager.maximumDecibel) dB")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray2)
            
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
    }
}

struct LiveDecibelChart: View {
    @EnvironmentObject var audioManager: AudioManager

    let frameWidth: CGFloat
    let frameHeight: CGFloat
    private let barWidth: CGFloat = 4
    private let barSpacing: CGFloat = 6
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(maxWidth: .infinity)
                .frame(height: frameHeight / 2) // 1/2 크기; 최대 소음에 해당하는 라인
            
            standardBar
                .frame(height: frameHeight) // 전체 크기; 최대 소음 * 2에 해당하는 라인
            
            HStack(spacing: barSpacing) {
                // 실제 데시벨 막대
                ForEach(audioManager.userDecibelBuffer.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Int(getDecibel(at: index)) > audioManager.maximumDecibel ? .pink : .green)
                        .frame(width: barWidth, height: decibelRowHeight(decibel: getDecibel(at: index)))
                }
                
                // 반대편에 보이지 않는 막대
                ForEach(audioManager.userDecibelBuffer.indices, id: \.self) { index in
                    if index != 0 {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: barWidth)
                    }
                }
            }
            .clipShape(Rectangle())
            .frame(width: frameWidth)
        }
        
    }
    
    private func getDecibel(at index: Int) -> Float {
        return audioManager.userDecibelBuffer[index]
    }
    
    private func decibelRowHeight(decibel: Float) -> CGFloat { // 화면 비율에 맞게끔 높이 조정
        min(frameHeight * CGFloat(decibel) / CGFloat(audioManager.maximumDecibel * 2), frameHeight) // 최대 소음 * 2를 넘지 않게
    }

    private func xOffset(at index: Int) -> CGFloat {
        let count: Int = audioManager.userDecibelBuffer.count - 1 - index
    
        return (frameWidth / 2) - (barWidth + barSpacing) * CGFloat(count)
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
