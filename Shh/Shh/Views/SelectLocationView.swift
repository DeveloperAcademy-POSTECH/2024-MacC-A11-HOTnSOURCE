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
        VStack(spacing: 16) {
            locationList
            
            createLocationButton
        }
        .navigationTitle("장소 선택")
        .scrollIndicators(.hidden)
    }
    
    // MARK: Subviews
    private var locationList: some View {
        ForEach(locationManager.locations.indices, id: \.self) { index in
            let location = locationManager.locations[index]
            
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
        .opacity(locationManager.locations.count >= 5 ? 0 : 1)
    }
    
    private func locationButton(_ location: Location) -> some View {
        ZStack(alignment: .trailing) {
            Button {
                routerManager.push(view: .mainView(selectedLocation: location))
                locationManager.selectedLocation = location
            } label: {
                locationButtonStyle(
                    title: location.name,
                    textColor: .white,
                    bgColor: locationManager.selectedLocation?.id == location.id ? .green : .gray
                )
            }
            
            Button {
                routerManager.push(view: .editLocationView(location: location))
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
}

// MARK: - Preview
#Preview {
    SelectLocationView()
}
