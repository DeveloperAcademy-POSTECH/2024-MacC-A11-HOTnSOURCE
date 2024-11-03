//
//  EditLocationView.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 장소 수정 뷰
struct EditLocationView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var locationManager: LocationManager
    
    @FocusState private var isFocused: Bool
    
    @State var location: Location
    @State private var isMetering: Bool = false
    @State private var showBackgroundNoiseInfo: Bool = false
    
    private var nameMaxLength: Int {
        let currentLocale = Locale.current.language.languageCode?.identifier
        switch currentLocale {
        case "en": return 15
        case "ko": return 8
        default: return 8
        }
    }
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 40) {
            nameRow
            
            backgroundNoiseRow
            
            distanceRow
            
            Spacer()
        }
        .navigationTitle("수정하기")
        .navigationBarTitleDisplayMode(.large)
        .padding(20)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                completeButton
            }
        }
        .sheet(isPresented: $showBackgroundNoiseInfo) {
            BackgroundNoistInfoSheet(backgroundNoise: location.backgroundDecibel)
        }
    }
    
    // MARK: SubViews
    private var nameRow: some View {
        VStack(alignment: .leading) {
            Text("이름")
                .font(.body)
                .fontWeight(.bold)
            
            nameTextField
        }
    }
    
    private var backgroundNoiseRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("배경 소음")
                .font(.body)
                .fontWeight(.bold)
            
            backgroundNoiseInfoRow
        }
    }
    
    private var backgroundNoiseInfoRow: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Location.decibelWriting(decibel: location.backgroundDecibel))
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button {
                    showBackgroundNoiseInfo = true
                } label: {
                    Label("자세한 정보", systemImage: "info.circle")
                        .labelStyle(.iconOnly)
                }
                .foregroundStyle(.secondary)
            }

            Spacer().frame(height: 8)

            Text("정도의 느낌이군요!")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center) 
        }
        .fontWeight(.bold)
    }
    
    private var distanceRow: some View {
        Text("측정 반경")
            .font(.body)
            .fontWeight(.bold)
    }
    
    private var nameTextField: some View {
        ZStack(alignment: .trailing) {
            TextField("이름을 입력해주세요", text: $location.name)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.tertiary)
                )
                .focused($isFocused)
                .onChange(of: location.name) {
                    if location.name.count > nameMaxLength {
                        location.name = String(location.name.prefix(nameMaxLength))
                    }
                }
            
            Text("\(location.name.count)/\(nameMaxLength)")
                .font(.caption2)
                .foregroundStyle(.gray)
                .padding(.trailing)
        }
    }
    
    private var completeButton: some View {
        Button {
            locationManager.editLocation(location)
            routerManager.pop()
            // TODO: 액션 약간 변경
        } label: {
            Text("완료")
        }
        .disabled(location.name.isEmpty || location.backgroundDecibel.isZero)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        EditLocationView(location: .init(id: UUID(), name: "도서관", backgroundDecibel: 65, distance: 2))
            .environmentObject(RouterManager())
            .environmentObject(LocationManager())
    }
}
