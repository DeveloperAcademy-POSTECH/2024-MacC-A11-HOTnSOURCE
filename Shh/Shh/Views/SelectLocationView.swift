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
                    bgColor: locationManager.selectedLocation?.id == location.id ? .green : .clear
                )
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
                    .padding(.trailing, 10)
            }
        }
    }
    
    private func locationButtonStyle(title: String, textColor: Color, bgColor: Color) -> some View {
        HStack {
            // TODO: 기기별 반응형 적합성 확인 필요
            Capsule()
                .fill(bgColor)
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
