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
    @EnvironmentObject var locationManager: LocationManager

    @State private var selectedToDeleteLocationIndex: Int?
    @State private var showDeleteAlert: Bool = false
    
    // MARK: Body
    var body: some View {
        locationList
            .navigationTitle("장소 선택")
            .toolbar { createLocationButton }
            .scrollIndicators(.hidden)
    }
    
    // MARK: Subviews
    private var locationList: some View {
        List {
            ForEach(locationManager.locations.indices, id: \.self) { index in
                let location = locationManager.locations[index]
                
                locationButton(location)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            selectedToDeleteLocationIndex = index
                            showDeleteAlert = true
                        } label: {
                            Label("Trash", systemImage: "trash.fill")
                        }
                        
                        Button(role: .cancel) {
                            routerManager.push(view: .editLocationView(location: location))
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                    }
            }
            .alert(isPresented: $showDeleteAlert) {
                guard let index = selectedToDeleteLocationIndex else {
                    return Alert(title: Text("오류"))
                }
                
                let location = locationManager.locations[index]
                
                return Alert(
                    title: Text("\(location.name) 삭제"),
                    message: Text("정말 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        locationManager.deleteLocation(location)
                        selectedToDeleteLocationIndex = nil
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
        }
        .padding(.top, 20)
    }
    
    private func locationButton(_ location: Location) -> some View {
        Button {
            routerManager.push(view: .mainView(selectedLocation: location))
            locationManager.selectedLocation = location
        } label: {
            HStack {
                locationButtonStyle(
                    title: location.name,
                    textColor: .white,
                    capsuleColor: locationManager.selectedLocation?.id == location.id ? .green : .clear
                )
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
                    .padding(.trailing, 10)
            }
        }
    }
    
    private func locationButtonStyle(title: String, textColor: Color, capsuleColor: Color) -> some View {
        HStack {
            Capsule()
                .fill(capsuleColor)
                .frame(width: 8)
                .padding(.vertical, 25)
                .padding(.trailing, 10)
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(textColor)
        }
    }
    
    private var createLocationButton: some View {
        Button {
            if locationManager.locations.count < 10 {
                routerManager.push(view: .createLocationView)
            }
        } label: {
            Text("생성하기")
        }
        .disabled(locationManager.locations.count >= 10)
    }
}

// MARK: - Preview
#Preview {
    SelectLocationView()
}
