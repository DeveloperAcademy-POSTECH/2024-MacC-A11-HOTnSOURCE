//
//  Wave.swift
//  Shh
//
//  Created by Jia Jang on 10/15/24.
//

import SwiftUI

// MARK: - 파도 모양을 그리는 Shape
struct Wave: Shape {
    var offSet: Angle // 파도의 가로 움직임을 조정하는 각도
    var percent: Double // 파도의 높이를 결정하는 퍼센트
    
    // 각도와 퍼센트 값을 동시에 애니메이팅할 수 있도록 관리하는 데이터
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(offSet.degrees, percent) }
        set {
            // 첫 번째 값으로 가로 움직임 각도 업데이트
            offSet = Angle(degrees: newValue.first)
            // 두 번째 값으로 파도의 높이 퍼센트 업데이트
            percent = newValue.second
        }
    }
    
    // rect(화면)에 파도의 모양을 그리는 함수
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        // 파도의 높이 범위 설정 (최저 높이, 최고 높이)
        let lowestWave = 0.02
        let highestWave = 1.00
        
        // 현재 퍼센트 값을 바탕으로 파도의 실제 높이를 계산
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        
        // 파도의 높이 설정, 화면 크기에 맞춰 스케일 조정
        let waveHeight = 0.015 * rect.height
        
        // 파도의 y 오프셋 계산 (파도의 기본 위치 설정)
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        
        // 파도의 시작 각도와 끝 각도 설정 (360도 회전)
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        // 파도의 시작점 설정, yOffset을 기준으로 높이 설정
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        // 5도 간격으로 각도를 변경하면서 가로로 파도를 그림
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            // 각도에 따라 x 좌표 계산
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            // 파도를 그리며 이동
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        // 파도를 화면 하단까지 채워서 닫기
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

// TODO: 애니메이션 디버깅 후 삭제 예정
struct WaveOffset: Shape {
    var offSet: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct WavePercent: Shape {
    var offSet: Angle
    var percent: Double
    
    var animatableData: Double {
        get { percent }
        set { percent = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}
