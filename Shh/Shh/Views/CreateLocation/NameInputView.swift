//
//  NameInputView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

// MARK: - 장소 생성 > 이름 입력 화면
struct NameInputView: View {
    // MARK: Properties
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var step: CreateLocationStep
    @Binding var name: String
    
    var isFocused: FocusState<Bool>.Binding
    
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
            StepDescriptionRow(
                text: "어디에서 사용하시나요?",
                subText: "소음 측정이 필요한 곳의 이름을 알려주세요"
            )
            
            Spacer(minLength: 80)
            
            nameInputRow
                .frame(maxHeight: .infinity, alignment: .top)
            
            NextStepButton(step: $step)
                .disabled(name.isEmpty || !locationManager.isValidName(name))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused.wrappedValue = false
        }
    }
    
    // MARK: SubViews
    private var nameInputRow: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .trailing) {
                TextField("이름을 입력해주세요", text: $name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .onChange(of: name) {
                        if name.count > nameMaxLength {
                            self.name = String(name.prefix(nameMaxLength))
                        }
                    }
                    .focused(isFocused)
                
                Text("\(name.count)/\(nameMaxLength)")
                    .font(.callout)
                    .foregroundStyle(.tertiary)
            }
            
            Rectangle()
                .frame(height: 3)
                .foregroundStyle(.accent)
            
            Text("중복되는 이름이 존재합니다!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
                .foregroundStyle(.red)
                .opacity(locationManager.isValidName(name) ? 0 : 1)
        }
    }
}

// MARK: - Preview
// #Preview {
//     NameInputView(step: .constant(.nameInput), name: .constant(""))
// }
