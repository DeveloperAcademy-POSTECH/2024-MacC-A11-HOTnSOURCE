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
    @EnvironmentObject var router: Router
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var audioManager: AudioManager
    
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
        VStack {
            nameRow
            
            Spacer().frame(minHeight: 5, maxHeight: 40)
            
            backgroundNoiseRow
            
            Spacer().frame(minHeight: 5, maxHeight: 40)
            
            distanceRow
            
            Spacer()
        }
        .navigationTitle("수정하기")
        .navigationBarTitleDisplayMode(.large)
        .padding(20)
        .background(.customBlack)
        .contentShape(Rectangle())
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            isFocused = false
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                completeButton
            }
        }
        .sheet(isPresented: $showBackgroundNoiseInfo) {
            BackgroundNoiseInfoSheet(backgroundNoise: location.backgroundDecibel)
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
            HStack {
                Text("배경 소음")
                    .font(.body)
                    .fontWeight(.bold)
                
                Button {
                    showBackgroundNoiseInfo = true
                } label: {
                    Label("자세한 정보", systemImage: "info.circle")
                        .labelStyle(.iconOnly)
                        .font(.footnote)
                }
                .foregroundStyle(.secondary)
            }
            
            backgroundNoiseField
        }
    }
    
    private var distanceRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("측정 반경")
                .font(.body)
                .fontWeight(.bold)
            
            DistanceInputField(distance: $location.distance)
        }
    }
    
    private var backgroundNoiseField: some View {
        HStack {
            if isMetering {
                Text("측정 중이에요...")
            } else {
                backgroundNoiseInfoRow
            }
            
            Spacer()
            
            meteringButton
                .padding(.vertical, 5)
        }
        .fontWeight(.bold)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.tertiary)
        }
    }
    
    private var backgroundNoiseInfoRow: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(Location.decibelWriting(decibel: location.backgroundDecibel))
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing)

            Text("정도의 느낌이군요!")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
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
    
    private var meteringButton: some View {
        MeteringBackgroundNoiseButton(backgroundNoise: $location.backgroundDecibel, isMetering: $isMetering, meteringAction: audioManager.meteringBackgroundNoise) {
            Label("측정하기", systemImage: "mic.fill")
                .labelStyle(.iconOnly)
                .padding()
                .background {
                    Circle()
                        .fill(.accent)
                }
                .accessibilityLabel("배경 소음 측정")
        }
    }
    
    private var completeButton: some View {
        Button {
            locationManager.editLocation(location)
            router.pop()
        } label: {
            Text("완료")
        }
        .disabled(location.name.isEmpty || location.backgroundDecibel.isZero)
    }
}

// MARK: - Preview
#Preview {
    @Previewable @StateObject var router = Router()
    @Previewable @StateObject var locationManager = LocationManager()
    @Previewable @StateObject var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    NavigationView {
        EditLocationView(location: .init(id: UUID(), name: "도서관", backgroundDecibel: 50, distance: 2))
            .environmentObject(router)
            .environmentObject(locationManager)
            .environmentObject(audioManager)
    }
}
