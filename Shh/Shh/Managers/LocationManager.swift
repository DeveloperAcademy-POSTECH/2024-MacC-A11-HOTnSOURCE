////
////  LocationManager.swift
////  Shh
////
////  Created by Eom Chanwoo on 10/26/24.
////
//
//import SwiftUI
//
//final class LocationManager: ObservableObject {
//	  static let shared = LocationManager()
//
//    @AppStorage("locations") private var storedLocations: String = "[]"
//    @AppStorage("selectedLocation") private var storedSelectedLocation: String = ""
//    
//    @Published var locations: [Location] = [] {
//        didSet {
//            saveLocations() // locations 배열이 변경될 때 자동 저장
//            IOSConnectivityManager.shared.sendLocationData(location: locations) // 변경된 데이터 Watch로 전송
//        }
//    }
//    
//    @Published var selectedLocation: Location? {
//        didSet {
//            saveSelectedLocation()
//        }
//    }
//    
//    // 초기화: 저장된 Location 로드
//    init() {
//        loadLocations()
//    }
//    
//    func createLocation(_ location: Location) {
//        locations.append(location)
//       
//    }
//    
//    func editLocation(_ location: Location) {
//        guard let index = locations.firstIndex(where: { $0.id == location.id }) else { return }
//        
//        locations[index] = location
//    }
//    
//    func deleteLocation(_ location: Location) {
//        locations.removeAll { $0.id == location.id }
//        
//        if selectedLocation == location {
//            selectedLocation = nil
//        }
//    }
//    
//    func isValidName(_ name: String) -> Bool {
//        return !locations.contains(where: { $0.name == name })
//    }
//    
//    func canCreateLocation() -> Bool {
//        return locations.count < 10
//    }
//    
//    func canDeleteLocation() -> Bool {
//        return locations.count > 1
//    }
//    
//    private func loadLocations() {
//        locations = decodeData(from: storedLocations) ?? []
//        
//        selectedLocation = decodeData(from: storedSelectedLocation)
//    }
//    
//    private func saveLocations() {
//        storedLocations = encodeData(locations) ?? "[]"
//    }
//    
//    private func saveSelectedLocation() {
//        if let selectedLocation = selectedLocation {
//            storedSelectedLocation = encodeData(selectedLocation) ?? ""
//        } else {
//            storedSelectedLocation = ""
//        }
//    }
//    
//    private func encodeData<T: Encodable>(_ data: T) -> String? {
//        do {
//            let encodedData = try JSONEncoder().encode(data)
//            return String(data: encodedData, encoding: .utf8)
//        } catch {
//            print("Failed to encode data:", error)
//            return nil
//        }
//    }
//    
//    private func decodeData<T: Decodable>(from jsonString: String) -> T? {
//        if jsonString.isEmpty {
//            return nil
//        }
//        
//        guard let data = jsonString.data(using: .utf8) else {
//            print("Failed to decode data: invalid string format")
//            return nil
//        }
//        
//        do {
//            return try JSONDecoder().decode(T.self, from: data)
//        } catch {
//            print("Failed to decode data:", error)
//            return nil
//        }
//    }
//}
