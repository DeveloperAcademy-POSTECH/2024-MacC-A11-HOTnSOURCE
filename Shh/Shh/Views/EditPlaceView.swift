//
//  EditPlaceView.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 장소 수정 뷰
struct EditPlaceView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    
    @AppStorage("places") private var storedPlacesData: String = "[]"
    @AppStorage("selectedPlace") private var storedSelectedPlace: String = ""
    
    @FocusState private var isFocused: Bool
    
    @State var place: Place
    @State var storedPlaces: [Place]
    @State private var selectedPlace: Place?
    @State private var showSelectBackgroundDecibelSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var isShowingProgressView: Bool = false
    
    private var nameMaxLength: Int {
        let currentLocale = Locale.current.language.languageCode?.identifier // 현재 언어 가져오기
        switch currentLocale {
        case "en": return 15
        case "ko": return 8
        default: return 8
        }
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            ScrollView {
                Spacer().frame(height: 20)
                
                VStack(alignment: .leading, spacing: 40) {
                    nameRow
                    
                    backgroundDecibelRow
                    
                    distanceRow
                    
                    Spacer().frame(height: 0)
                    
                    actionButtonStack
                }
            }
            
            if isShowingProgressView {
                Color(.black)
                    .opacity(0.4)
                    .ignoresSafeArea(.all)
                
                ProgressView()
            }
        }
        .navigationTitle("수정하기")
        .padding(.horizontal, 30)
        .scrollIndicators(.hidden)
        .scrollDisabled(true)
        .sheet(isPresented: $showSelectBackgroundDecibelSheet) {
            selectBackgroundDecibelSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .alert("\(place.name) 삭제", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                deletePlace(place)
                routerManager.pop()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("정말 삭제하시겠습니까?")
        }
        .onTapGesture {
            isFocused = false
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
    
    private var backgroundDecibelRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .bottom) {
                Text("배경 소음")
                    .font(.body)
                    .fontWeight(.bold)
                
                Spacer()
                
                BackgroundDecibelMeteringButton(backgroundDecibel: $place.backgroundDecibel, isShowingProgressView: $isShowingProgressView)
            }
            Text("기준이 될 현장의 배경 소음을 측정하거나 입력해주세요\n기준보다 큰 소리를 내시면 알려드릴게요")
                .font(.caption2)
                .foregroundStyle(.gray)
            
            Spacer().frame(height: 5)
            
            backgroundDecibelSelectRow
        }
    }
    
    private var distanceRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("측정 반경")
                .font(.callout)
                .fontWeight(.bold)
            
            Text("조심해야할 대상과의 거리를 측정하거나 입력해주세요\n그 곳에서 느낄 당신의 소리 크기를 알려드릴게요")
                .font(.caption2)
                .foregroundStyle(.gray)
            
            Spacer().frame(height: 5)
            
            disatanceSelectRow
        }
    }
    
    private var actionButtonStack: some View {
        VStack {
            completeButton
            
            Spacer().frame(height: 20)
            
            deleteButton
        }
    }
    
    private var selectBackgroundDecibelSheet: some View {
        VStack(spacing: 30) {
            VStack {
                // TODO: 위아래 패딩 수정 예정
                Text(Place.decibelWriting(decibel: place.backgroundDecibel))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(10)
                
                // TODO: 예시 추가 예정
//                Text(Place.decibelExample(decibel: backgroundDecibel))
//                    .font(.callout)
//                    .fontWeight(.medium)
//                    .foregroundStyle(.gray)
//                    .lineLimit(8)
            }
            
            Divider()
            
            Picker("", selection: $place.backgroundDecibel) {
                ForEach(Array(stride(from: 30.0, to: 75.0, by: 5.0)), id: \.self) { value in
                    Text("\(Int(value))")
                        .tag(Float(value))
                }
            }
            .pickerStyle(.wheel)
        }
        .padding()
    }
    
    private var nameTextField: some View {
        ZStack(alignment: .trailing) {
            TextField("이름을 입력해주세요", text: $place.name)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.tertiary)
                )
                .focused($isFocused)
                .onChange(of: place.name) { newValue in
                    if newValue.count > nameMaxLength {
                        place.name = String(newValue.prefix(nameMaxLength))
                    }
                }
            
            Text("\(place.name.count)/\(nameMaxLength)")
                .font(.caption2)
                .foregroundStyle(.gray)
                .padding(.trailing)
        }
    }
    
    private var backgroundDecibelSelectRow: some View {
        HStack {
            Text("크기")
                .font(.callout)
                .fontWeight(.bold)
            
            Spacer()
            
            backgroundDecibelSelectButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.quaternary)
        )
    }
    
    private var backgroundDecibelSelectButton: some View {
        Button {
            showSelectBackgroundDecibelSheet = true
        } label: {
            HStack(alignment: .bottom, spacing: 3) {
                Text("\(Int(place.backgroundDecibel))")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("dB")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .frame(width: 95, height: 45)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.quaternary)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var disatanceSelectRow: some View {
        HStack {
            Text("거리")
                .font(.callout)
                .fontWeight(.bold)
            
            Spacer()
            
            distanceSelectButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.quaternary)
        )
    }
    
    private var distanceSelectButton: some View {
        HStack(spacing: 12) {
            distanceAdjustButton(isPlus: false)
            
            distanceInfo
            
            distanceAdjustButton(isPlus: true)
        }
    }
    
    private var distanceInfo: some View {
        HStack(alignment: .bottom, spacing: 3) {
            Text("\(String(place.distance))")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("m")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(width: 55)
    }
    
    @ViewBuilder
    private func distanceAdjustButton(isPlus: Bool) -> some View {
        Button {
            if isPlus && place.distance < 3 {
                place.distance += 0.5
            } else if !isPlus && place.distance > 1 {
                place.distance -= 0.5
            }
            
        } label: {
            Image(systemName: isPlus ? "plus" : "minus")
                .font(.caption2)
                .frame(width: 18, height: 18)
                .padding(4)
                .background(
                    Circle()
                        .foregroundStyle(.quaternary)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var completeButton: some View {
        Button {
            editPlace(place)
            routerManager.pop()
        } label: {
            Text("완료")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: 350)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                )
        }
        .disabled(place.name.isEmpty || place.backgroundDecibel.isZero)
    }
    
    private var deleteButton: some View {
        Button {
            showDeleteAlert = true
        } label: {
            Label("장소 삭제하기", systemImage: "trash")
        }
        .font(.callout)
        .disabled(!canDeletePlace())
        .foregroundStyle(canDeletePlace() ? .red : .gray)
    }
    
    // MARK: Action Handlers
    private func editPlace(_ place: Place) {
        var storedPlaces: [Place] = []
        
        if let data = storedPlacesData.data(using: .utf8), let decodedPlaces = try? JSONDecoder().decode([Place].self, from: data) {
            storedPlaces = decodedPlaces
        }
        
        if let index = storedPlaces.firstIndex(where: { $0.id == place.id }) {
            storedPlaces[index] = place
        } else {
            print("해당 장소 없음")
        }
        
        if let encodedData = try? JSONEncoder().encode(storedPlaces), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedPlacesData = jsonString
        }
    }
    
    private func canDeletePlace() -> Bool {
        return storedPlaces.count > 1
    }
    
    private func deletePlace(_ place: Place) {
        storedPlaces.removeAll { $0.id == place.id }
        
        if let encodedData = try? JSONEncoder().encode(storedPlaces), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedPlacesData = jsonString
        }
        
        checkIsSelectedPlace()
    }
    
    private func checkIsSelectedPlace() {
        if let data = storedSelectedPlace.data(using: .utf8),
            let decodedPlaces = try? JSONDecoder().decode(Place.self, from: data) {
                selectedPlace = decodedPlaces
        }
        
        if let selectedPlace = self.selectedPlace, selectedPlace == place {
            storedSelectedPlace = ""
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        EditPlaceView(place: .init(id: UUID(), name: "도서관", backgroundDecibel: 50, distance: 2), storedPlaces: [])
    }
}