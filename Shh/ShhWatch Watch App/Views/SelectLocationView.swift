//
//  SelectLocationView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 장소 선택 뷰: iOS에서 가져온 장소 리스트를 보여줌
struct SelectLocationView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    @ObservedObject var model = WatchConnectivityManager()
    
    @State private var selectedPlace: Location?
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            locationList
        }
        .navigationTitle("장소 선택")
        .scrollIndicators(.hidden)
    }
    
    // MARK: Subviews
    private var locationList: some View {
        List {
            ForEach(model.locations) { location in
                locationButton(location)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    // action
                } label: {
                    Label("Trash", systemImage: "trash.fill")
                }
            }
        }
    }
    
    // MARK: Subviews
    private var placeList: some View {
        List {
            ForEach(model.locations) { location in
                locationButton(location)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    // action
                } label: {
                    Label("Trash", systemImage: "trash.fill")
                }
            }
        }
    }
    
    private func locationButton(_ location: Location) -> some View {
        Button {
            routerManager.push(view: .mainView)
        } label: {
            Text(location.name)
        }
        .foregroundStyle(.white)
        .tint(selectedPlace?.id == location.id ? .green : .gray)
    }
}

#Preview {
    SelectLocationView()
}
