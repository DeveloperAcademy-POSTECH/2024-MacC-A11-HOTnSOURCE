//
//  SelectPlaceView.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 장소 선택 뷰
struct SelectPlaceView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    
    @AppStorage("places") private var storedPlacesData: String = "[]"
    @AppStorage("selectedPlace") private var storedSelectedPlace: String = ""

    @State private var storedPlaces: [Place] = []
    @State private var selectedPlace: Place?
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            placeList
            
            createPlaceButton
        }
        .navigationTitle("장소 선택")
        .onAppear {
            loadPlaces()
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: Subviews
    private var placeList: some View {
        ForEach(storedPlaces.indices, id: \.self) { index in
            let place = storedPlaces[index]
            
            placeButton(place)
        }
    }
    
    private var createPlaceButton: some View {
        Button {
            routerManager.push(view: .createPlaceView)
        } label: {
            placeButtonStyle(title: "+", textColor: .white, bgColor: .gray)
                .opacity(0.5)
        }
        .opacity(storedPlaces.count >= 5 ? 0 : 1)
    }
    
    private func placeButton(_ place: Place) -> some View {
        ZStack(alignment: .trailing) {
            Button {
                routerManager.push(view: .mainView(selectedPlace: place))
                selectedPlace = place
                saveSelectedPlace()
            } label: {
                placeButtonStyle(
                    title: place.name,
                    textColor: .white,
                    bgColor: selectedPlace?.id == place.id ? .green : .gray
                )
            }
            
            Button {
                routerManager.push(view: .editPlaceView(place: place, storedPlaces: storedPlaces))
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.white)
                    .padding()
                    .contentShape(Rectangle())
            }
        }
    }
    
    private func placeButtonStyle(title: String, textColor: Color, bgColor: Color) -> some View {
        Text(title)
            .font(.title3)
            .bold()
            .foregroundColor(textColor)
            .padding(.vertical, 20)
            .frame(width: 300)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(bgColor)
            )
    }
    
    // MARK: Action Handlers
    private func loadPlaces() {
        if let data = storedPlacesData.data(using: .utf8),
            let decodedPlaces = try? JSONDecoder().decode([Place].self, from: data) {
                storedPlaces = decodedPlaces
        }
        
        if let data = storedSelectedPlace.data(using: .utf8),
            let decodedPlaces = try? JSONDecoder().decode(Place.self, from: data) {
                selectedPlace = decodedPlaces
        }
        
        if storedPlaces.isEmpty {
            let defaultPlace: Place = .init(id: UUID(), name: "도서관", averageNoise: 40, distance: 1)
            
            storedPlaces = [defaultPlace]
            selectedPlace = defaultPlace
            
            savePlaces()
            saveSelectedPlace()
            
            routerManager.push(view: .mainView(selectedPlace: defaultPlace))
        }
        
    }

    private func saveSelectedPlace() {
        if let selectedPlace = self.selectedPlace, let encodedData = try? JSONEncoder().encode(selectedPlace), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedSelectedPlace = jsonString
        }
    }
    
    private func savePlaces() {
        if let encodedData = try? JSONEncoder().encode(storedPlaces), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedPlacesData = jsonString
        }
    }
}

// MARK: - Preview
#Preview {
    SelectPlaceView()
}
