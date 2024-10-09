//
//  NoiseView.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 메인 데시벨 뷰
struct NoiseView: View {
    // MARK: Properties
    @State private var isAnimating = false
    @State private var drawingStroke = false
    
    private var status: String = "양호"
    private var decibel: Int = 30
    
    // MARK: Body
    var body: some View {
        ZStack {
            backgroundCard
            cardContents
        }
        // TODO: 네비게이션 타이틀 동적으로 변경 필요
        .navigationTitle("도서관")
        .padding(30)
    }
    
    // MARK: Subviews
    private var backgroundCard: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray)
            .opacity(0.5)
    }
    
    private var cardContents: some View {
        VStack(spacing: 45) {
            statusArea
            infoArea
            pauseButton
        }
        .padding(30)
    }
    
    private var statusArea: some View {
        ZStack {
            gradientCircles
            cicularProgressBar
            statusInfo
        }
    }
    
    private var gradientCircles: some View {
        // TODO: 애니메이션 어긋나는 문제 해결 필요
        ZStack {
            gradientCircle
                .frame(width: 230)
            
            gradientCircle
                .frame(width: 280)
        }
    }
    
    private var gradientCircle: some View {
        Circle()
            .fill(status == "양호" ? .green : .orange)
            .opacity(0.2)
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
    
    private var cicularProgressBar: some View {
        ZStack {
            Circle()
                .fill(.black)
                .frame(width: 160)
                .background {
                    Circle()
                        .trim(from: 0, to: drawingStroke ? 1 : 0)
                        .stroke(status == "양호" ? .green : .orange,
                            style: StrokeStyle(lineWidth: 7, lineCap: .round))
                        .padding(-5)
                }
                .rotationEffect(.degrees(-90))
                .animation(Animation
                    .easeOut(duration: 6)
                    .repeatForever(autoreverses: false)
                    .delay(0.5), value: drawingStroke)
                .onAppear {
                    drawingStroke.toggle()
                }
        }
    }
    
    private var statusInfo: some View {
        VStack {
            Text(status)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            Text("\(decibel)dB")
                .font(.subheadline)
                .bold()
                .foregroundColor(.gray)
        }
    }
    
    private var infoArea: some View {
        ZStack {
            infoText
            helpButton
        }
    }
    
    private var infoText: some View {
        VStack(spacing: 4) {
            VStack(spacing: 2) {
                Text("반경 5m")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("에서는")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 2) {
                Text("일상적인 대화")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Text("수준으로 들려요")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var helpButton: some View {
        HStack {
            Spacer()
            
            Button {
                // action
            } label: {
                Text("?")
                    .font(.caption)
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .fill(.gray)
                            .frame(width: 18)
                    }
            }
        }
    }
    
    private var pauseButton: some View {
        Button {
            // action
        } label: {
            Text("잠시 멈춤")
                .foregroundColor(.white)
                .bold()
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray)
                }
        }
    }
}

#Preview {
    NoiseView()
}
