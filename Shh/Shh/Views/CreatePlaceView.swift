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
    
    @FocusState private var isFocused: Bool
    
    @State private var name: String = ""
    @State private var averageNoise: Float = 0
    @State private var distance: Float = 1
    @State private var showSelectAverageNoiseSheet: Bool = false
    
    // MARK: Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 48) {
                nameRow
                
                averageNoiseRow
                
                distanceRow
                
                Spacer().frame(height: 0)
                
                completeButton
            }
        }
        .navigationTitle("생성하기")
        .padding(30)
        .sheet(isPresented: $showSelectAverageNoiseSheet) {
            selectAverageNoiseSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
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
            
            TextField("이름을 입력해주세요", text: $name)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.tertiary)
                )
                .focused($isFocused)
        }
    }
    
    private var averageNoiseRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("평균 소음")
                .font(.body)
                .bold()
            
            Text("기준이 될 현장의 평균 소음을 측정하거나 입력해주세요\n기준보다 큰 소리를 내시면 알려드릴게요")
                .font(.caption2)
                .foregroundStyle(.gray)
            
            Spacer().frame(height: 5)
            
            averageNoiseSelectRow
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
            let newPlace = Place(id: UUID(), name: name, averageNoise: averageNoise, distance: distance)
            
            createPlace(newPlace)
            
            routerManager.pop()
        } label: {
            Text("완료")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: 350)
                .frame(height: 65)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                )
        }
        .disabled(name.isEmpty || averageNoise.isZero)
    }
    
    private var selectAverageNoiseSheet: some View {
        VStack(spacing: 30) {
            VStack {
                Text("조용한 카페에서의")
                Text("소음이에요")
            }
            .font(.title)
            .fontWeight(.semibold)
            
            Divider()
            
            Picker("", selection: $averageNoise) {
                ForEach(Array(stride(from: 30.0, to: 75.0, by: 5.0)), id: \.self) { value in
                    Text("\(Int(value))")
                        .tag(Float(value))
                }
            }
            .pickerStyle(.wheel)
        }
        .padding()
    }
    
    private var averageNoiseSelectRow: some View {
        HStack {
            Text("크기")
                .font(.callout)
                .bold()
            
            Spacer()
            
            averageNoiseSelectButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.quaternary)
        )
    }
    
    private var averageNoiseSelectButton: some View {
        Button {
            showSelectAverageNoiseSheet = true
        } label: {
            HStack(alignment: .bottom, spacing: 3) {
                Text("\(Int(averageNoise))")
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
    private func createPlace(_ place: Place) {
        var storedPlaces: [Place] = []
        
        if let data = storedPlacesData.data(using: .utf8),
            let decodedPlaces = try? JSONDecoder().decode([Place].self, from: data) {
                storedPlaces = decodedPlaces
        }
        
        storedPlaces.append(place)
        
        if let encodedData = try? JSONEncoder().encode(storedPlaces), let jsonString = String(data: encodedData, encoding: .utf8) {
            storedPlacesData = jsonString
        }
    }
}

// MARK: - Preview
#Preview {
    CreatePlaceView()
}
