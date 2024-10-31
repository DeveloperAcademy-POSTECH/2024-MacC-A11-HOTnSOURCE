//
//  LocationManager.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/26/24.
//

import SwiftUI

final class LocationManager: ObservableObject {
    @AppStorage("locations") private var storedLocations: String = "[]"
    @AppStorage("selectedLocation") private var storedSelectedLocation: String = ""
    
    @ObservedObject private var iosConnectivityManager = IOSConnectivityManager.shared
    
    @Published var locations: [Location] = [] {
        didSet {
            saveLocations() // locations 배열이 변경될 때 자동 저장
        }
    }
    
    @Published var selectedLocation: Location? {
        didSet {
            saveSelectedLocation()
        }
    }
    
    init() {
        loadLocations()
    }
    
    // TODO: 워크스루 생성에 맞게 분리 필요
    func createLocation(_ location: Location) -> CreateLocationResult {
        guard !locations.contains(where: { $0.name == location.name }) else {
            return .duplicateName
        }
        
        guard locations.count < 5 else {
            return .overCapacity
        }
        
        locations.append(location)
        
        // Location 추가 후 Watch로 전송
        iosConnectivityManager.sendLocationData(location: locations)
        
        return .success
    }
    
    func editLocation(_ location: Location) {
        guard let index = locations.firstIndex(where: { $0.id == location.id }) else { return }
        
        locations[index] = location
        
        // Location 수정 후 변경된 데이터 Watch로 전송
        iosConnectivityManager.sendLocationData(location: locations)
    }
    
    func deleteLocation(_ location: Location) {
        locations.removeAll { $0.id == location.id }
        
        if selectedLocation == location {
            selectedLocation = nil
        }
        
        // Location 삭제 후 변경된 데이터 Watch로 전송
        iosConnectivityManager.sendLocationData(location: locations)
    }
    
    func canDeleteLocation() -> Bool {
        return locations.count > 1
    }
    
    private func loadLocations() {
        locations = decodeData(from: storedLocations) ?? []
        
        selectedLocation = decodeData(from: storedSelectedLocation)
    }
    
    private func saveLocations() {
        storedLocations = encodeData(locations) ?? "[]"
    }
    
    private func saveSelectedLocation() {
        if let selectedLocation = selectedLocation {
            storedSelectedLocation = encodeData(selectedLocation) ?? ""
        } else {
            storedSelectedLocation = ""
        }
    }
    
    private func encodeData<T: Encodable>(_ data: T) -> String? {
        do {
            let encodedData = try JSONEncoder().encode(data)
            return String(data: encodedData, encoding: .utf8)
        } catch {
            print("Failed to encode data:", error)
            return nil
        }
    }
    
    private func decodeData<T: Decodable>(from jsonString: String) -> T? {
        if jsonString.isEmpty {
            return nil
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            print("Failed to decode data: invalid string format")
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to decode data:", error)
            return nil
        }
    }
}

enum CreateLocationResult {
    case success
    case duplicateName
    case overCapacity
    case unknown
    
    var message: LocalizedStringKey {
        switch self {
        case .success:
            return "장소 생성 성공"
        case .duplicateName:
            return "중복되는 이름이 존재합니다"
        case .overCapacity:
            return "장소는 최대 5개까지 생성 가능합니다"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
}
