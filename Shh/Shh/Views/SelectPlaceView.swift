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
            ForEach(storedPlaces.indices, id: \.self) { index in
                let place = storedPlaces[index]
                
                ZStack(alignment: .trailing) {
                    Button {
                        routerManager.push(view: .noiseView(selectedPlace: place))
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
                        routerManager.push(view: .editPlaceView(place: place))
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.white)
                            .padding()
                            .contentShape(Rectangle())
                    }
                }
            }
            
            Button {
                routerManager.push(view: .createPlaceView)
            } label: {
                placeButtonStyle(title: "+", textColor: .white, bgColor: .gray)
                    .opacity(0.5)
            }
        }
        .navigationTitle("장소 선택")
        .onAppear {
            loadPlaces()
        }
    }
    
    // MARK: Subviews
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
    }

    private func saveSelectedPlace() {
        if let selectedPlace = self.selectedPlace, let encodedData = try? JSONEncoder().encode(selectedPlace), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedSelectedPlace = jsonString
        }
    }
}

// MARK: - Preview
#Preview {
    SelectPlaceView()
}

////
////  TempView.swift
////  Shh
////
////  Created by Eom Chanwoo on 10/8/24.
////
//
//import SwiftUI
//
//struct TempView: View {
//    @AppStorage("places") private var storedPlacesData: String = "[]"
//    @AppStorage("lastPlace") private var storedLastPlace: String = ""
//    
//    @State private var storedPlaces: [Place] = []
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
////                ForEach($storedPlaces) { $place in
////                    HStack {
////                        Text(place.name)
////                        Text("\(place.averageNoise) dB")
////                        Text("\(place.distance) km")
////                        NavigationLink("Edit Place") {
////                            EditPlaceView(place: $place, onSave: {
////                                savePlaces() // Place 수정 후 배열 전체를 저장
////                            })
////                        }
////                    }
////                }
//                
////               @State 배열을 바인딩하기 위해선 인덱스 기반 바인딩을 해야한다!!
//                ForEach(storedPlaces.indices, id: \.self) { index in
//                    HStack {
//                        Text(storedPlaces[index].name)
//                        Text("\(storedPlaces[index].averageNoise) dB")
//                        Text("\(storedPlaces[index].distance) km")
//                        NavigationLink("Edit") {
//                            EditPlaceView(place: $storedPlaces[index], onSave: {
//                                savePlaces()
//                            })
//                        }
//                    }
//                }
//                NavigationLink {
//                    CreatePlaceView(action: createPlace)
//                } label: {
//                    Text("Create")
//                }
//
//            }
//        }
//        .onAppear(perform: loadPlaces)
//    }
//}
