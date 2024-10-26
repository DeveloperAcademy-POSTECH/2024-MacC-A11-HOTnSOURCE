//
//  SelectLocationView.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 장소 선택 뷰
struct SelectLocationView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    
    @AppStorage("locations") private var storedLocationsData: String = "[]"
    @AppStorage("selectedLocation") private var storedSelectedLocation: String = ""

    @State private var storedLocations: [Location] = []
    @State private var selectedLocation: Location?
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            locationList
            
            createLocationButton
        }
        .navigationTitle("장소 선택")
        .onAppear {
            loadLocations()
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: Subviews
    private var locationList: some View {
        ForEach(storedLocations.indices, id: \.self) { index in
            let location = storedLocations[index]
            
            locationButton(location)
        }
    }
    
    private var createLocationButton: some View {
        Button {
            routerManager.push(view: .createLocationView)
        } label: {
            locationButtonStyle(title: "+", textColor: .white, bgColor: .gray)
                .opacity(0.5)
        }
        .opacity(storedLocations.count >= 5 ? 0 : 1)
    }
    
    private func locationButton(_ location: Location) -> some View {
        ZStack(alignment: .trailing) {
            Button {
                routerManager.push(view: .mainView(selectedLocation: location))
                selectedLocation = location
                saveSelectedLocation()
            } label: {
                locationButtonStyle(
                    title: location.name,
                    textColor: .white,
                    bgColor: selectedLocation?.id == location.id ? .green : .gray
                )
            }
            
            Button {
                routerManager.push(view: .editLocationView(location: location, storedLocations: storedLocations))
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.white)
                    .padding()
                    .contentShape(Rectangle())
            }
        }
    }
    
    private func locationButtonStyle(title: String, textColor: Color, bgColor: Color) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(textColor)
            .padding(.vertical, 20)
            .frame(width: 300)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(bgColor)
            )
    }
    
    // MARK: Action Handlers
    private func loadLocations() {
        if let data = storedLocationsData.data(using: .utf8),
            let decodedLocations = try? JSONDecoder().decode([Location].self, from: data) {
                storedLocations = decodedLocations
        }
        
        if let data = storedSelectedLocation.data(using: .utf8),
            let decodedLocations = try? JSONDecoder().decode(Location.self, from: data) {
                selectedLocation = decodedLocations
        }
        
        if storedLocations.isEmpty {
            let defaultLocationName = NSLocalizedString("도서관", comment: "기본 장소 이름")
            let defaultLocation: Location = .init(id: UUID(), name: defaultLocationName, backgroundDecibel: 40, distance: 1)
            
            storedLocations = [defaultLocation]
            selectedLocation = defaultLocation
            
            saveLocations()
            saveSelectedLocation()
            
            routerManager.push(view: .mainView(selectedLocation: defaultLocation))
        }
        
    }

    private func saveSelectedLocation() {
        if let selectedLocation = self.selectedLocation, let encodedData = try? JSONEncoder().encode(selectedLocation), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedSelectedLocation = jsonString
        }
    }
    
    private func saveLocations() {
        if let encodedData = try? JSONEncoder().encode(storedLocations), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedLocationsData = jsonString
        }
    }
}

// MARK: - Preview
#Preview {
    SelectLocationView()
}
