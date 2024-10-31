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
    @StateObject var connectivityManager = WatchConnectivityManager()
    
    @State private var selectedLocation: Location?
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            locationList
        }
        .navigationTitle("장소 선택")
    }
    
    // MARK: Subviews
    private var locationList: some View {
        List {
            ForEach(connectivityManager.locations) { location in
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
            routerManager.push(view: .mainView(selectedLocation: location))
        } label: {
            Text(location.name)
        }
        .foregroundStyle(.white)
        .tint(selectedLocation?.id == location.id ? .green : .gray)
    }
}

#Preview {
    SelectLocationView()
}
