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

    @Published var locations: [Location] = []
    
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
        if locations.contains(where: { $0.name == location.name }) {
            return .duplicateName
        } else if locations.count > 5 {
            return .overCapacity
        }
        
        locations.append(location)
        
        saveLocations()
        return .success
    }
    
    func editLocation(_ location: Location) {
        guard let index = locations.firstIndex(where: { $0.id == location.id })
        else { return }
        
        locations[index] = location
        
        saveLocations()
    }
    
    func deleteLocation(_ location: Location) {
        locations.removeAll { $0.id == location.id }
        
        saveLocations()
        
        if selectedLocation == location {
            selectedLocation = nil
        }
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
        storedSelectedLocation = selectedLocation.flatMap { encodeData($0) } ?? ""
    }
    
    private func encodeData<T: Encodable>(_ data: T) -> String? {
        guard let encodedData = try? JSONEncoder().encode(data), let jsonString = String(data: encodedData, encoding: .utf8)
        else {
            print("Failed to encode data")
            return nil
        }
        
        return jsonString
    }
    
    private func decodeData<T: Decodable>(from jsonString: String) -> T? {
        guard let data = jsonString.data(using: .utf8)
        else {
            print("Failed to decode data")
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
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
