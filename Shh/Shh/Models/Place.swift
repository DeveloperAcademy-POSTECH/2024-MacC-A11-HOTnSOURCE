//
//  File.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/11/24.
//

import Foundation

struct Place: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var backgroundDecibel: Float
    var distance: Float
}

extension Place {
    /// 선택 가능한 거리입니다. 현재는 1m 부터, 3m까지 지원합니다.
    static let distanceOptions: [Float] = [1.0, 1.5, 2.0, 2.5, 3.0]
    
    /// 선택 가능한 배경 소음입니다. 현재는 30 dB부터 70 dB까지 지원합니다.
    static let backgroundDecibelOptions: [Float] = [30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0]
    
    /// 해당 데시벨에 대한 설명입니다. 이를 통해 사용자가 데시벨 정도를 가늠할 수 있습니다.
    static func decibelWriting(decibel: Float) -> String {
        let intDecibel = Int(decibel)
        
        switch intDecibel {
        case 30:
            return "아주 조용한 방에서의 환경음"
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

    // TODO: 예시 수정 예정
    /// 해당 데시벨에 대한 예시입니다.
    static func decibelExample(decibel: Float) -> String {
        let intDecibel = Int(decibel)
        
        switch intDecibel {
        case 30:
            return "가만히 있는 방, 시골의 조용한 밤"
        case 35:
            return "작동 중인 냉장고 소리, 잔잔한 바람 소리"
        case 40:
            return "공부 중인 학생들이 많은 도서관의 소리"
        case 45:
            return "거실에서 멀리서 들리는 TV 소리, 주택가 실내 소음"
        case 50:
            return "조용한 사무실에서 컴퓨터 팬 소리, 주행 중인 차량 내부"
        case 55:
            return "일상적인 대화 소리, 조용한 가정 내의 소음"
        case 60:
            return "활발한 대화 소리, 조용한 도로에서의 자동차 소리"
        case 65:
            return "시끄러운 사무실, 토론하는 사람들의 소리"
        case 70:
            return "도로변에서 자동차와 사람들 소리가 혼합된 시끄러운 소리"
        case 0:
            return ""
        default:
            return "예시 없음"
        }
    }
}
