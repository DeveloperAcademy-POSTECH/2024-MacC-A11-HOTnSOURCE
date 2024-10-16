//
//  CreatePlaceView.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 장소 생성 뷰
struct CreatePlaceView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    
    @AppStorage("places") private var storedPlacesData: String = "[]"
    @AppStorage("selectedPlace") private var storedSelectedPlace: String = ""
    
    @FocusState private var isFocused: Bool
    
    @State private var name: String = ""
    @State private var backgroundDecibel: Float = 0
    @State private var distance: Float = 1
    @State private var showSelectBackgroundDecibelSheet: Bool = false
    @State private var createFail: Bool = false
    @State private var createResult: CreatePlaceResult?
    @State private var isShowingProgressView: Bool = false
    
    // MARK: Body
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    nameRow
                    
                    backgroundDecibelRow
                    
                    distanceRow
                    
                    Spacer().frame(height: 0)
                    
                    completeButton
                }
            }
            
            if isShowingProgressView {
                Color(.black)
                    .opacity(0.4)
                    .ignoresSafeArea(.all)
                
                ProgressView()
            }
        }
        .navigationTitle("생성하기")
        .padding(.horizontal, 30)
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showSelectBackgroundDecibelSheet) {
            selectBackgroundDecibelSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .alert("장소 생성 실패", isPresented: $createFail) {
            Button("확인", role: .cancel) {
                name = ""
            }
        } message: {
            Text(createResult?.rawValue ?? CreatePlaceResult.unknown.rawValue)
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
                .bold()
            
            nameTextField
        }
    }
    
    private var backgroundDecibelRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .bottom) {
                Text("배경 소음")
                    .font(.body)
                    .bold()
                
                Spacer()
                
                BackgroundDecibelMeteringButton(backgroundDecibel: $backgroundDecibel, isShowingProgressView: $isShowingProgressView)
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
                .bold()
            
            Text("조심해야할 대상과의 거리를 측정하거나 입력해주세요\n그 곳에서 느낄 당신의 소리 크기를 알려드릴게요")
                .font(.caption2)
                .foregroundStyle(.gray)
            
            Spacer().frame(height: 5)
            
            disatanceSelectRow
        }
    }
    
    private var completeButton: some View {
        Button {
            let newPlace = Place(id: UUID(), name: name, backgroundDecibel: backgroundDecibel, distance: distance)
            
            if createPlace(newPlace) {
                saveNewSelectedPlace(newPlace)
                
                routerManager.pop()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    routerManager.push(view: .mainView(selectedPlace: newPlace))
                }
            } else {
                createFail = true
            }
        } label: {
            Text("완료")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: 350)
                .frame(height: 56)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                }
        }
        .disabled(name.isEmpty || backgroundDecibel.isZero)
    }
    
    private var selectBackgroundDecibelSheet: some View {
        VStack(spacing: 30) {
            VStack {
                // TODO: 위아래 패딩 수정 예정
                Text(Place.decibelWriting(decibel: backgroundDecibel))
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
            
            Picker("", selection: $backgroundDecibel) {
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
            TextField("이름을 입력해주세요", text: $name)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.tertiary)
                )
                .focused($isFocused)
                .onChange(of: name) { newValue in
                    if newValue.count > 8 {
                        name = String(newValue.prefix(8))
                    }
                }
            
            Text("\(name.count)/8")
                .font(.caption2)
                .foregroundStyle(.gray)
                .padding(.trailing)
        }
    }
    
    private var backgroundDecibelSelectRow: some View {
        HStack {
            Text("크기")
                .font(.callout)
                .bold()
            
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
                Text("\(Int(backgroundDecibel))")
                    .font(.title2)
                    .bold()
                
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
                .bold()
            
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
            Text("\(String(distance))")
                .font(.title2)
                .bold()
            
            Text("m")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(width: 55)
    }
    
    @ViewBuilder
    private func distanceAdjustButton(isPlus: Bool) -> some View {
        Button {
            if isPlus && distance < 3 {
                distance += 0.5
            } else if !isPlus && distance > 1 {
                distance -= 0.5
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
    
    // MARK: Action Handlers
    private func createPlace(_ place: Place) -> Bool {
        var storedPlaces: [Place] = []
        
        if let data = storedPlacesData.data(using: .utf8),
            let decodedPlaces = try? JSONDecoder().decode([Place].self, from: data) {
                storedPlaces = decodedPlaces
        }
        
        if storedPlaces.contains(where: { $0.name == place.name }) {
            self.createResult = .duplicateName
            return false
        } else if storedPlaces.count > 5 {
            self.createResult = .overCapacity
            return false
        }
        
        storedPlaces.append(place)
        
        if let encodedData = try? JSONEncoder().encode(storedPlaces), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedPlacesData = jsonString
            self.createResult = .success
            return true
        }
        
        storedPlaces.removeAll { $0.id == place.id }
        self.createResult = .unknown
        return false
    }
    
    private func saveNewSelectedPlace(_ newPlace: Place) {
        if let encodedData = try? JSONEncoder().encode(newPlace), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedSelectedPlace = jsonString
        }
    }
}

enum CreatePlaceResult: String {
    case success
    case duplicateName = "중복되는 이름이 존재합니다"
    case overCapacity = "장소는 최대 5개까지 생성 가능합니다"
    case unknown = "알 수 없는 오류가 발생했습니다"
}

// MARK: - Preview
#Preview {
    CreatePlaceView()
}
