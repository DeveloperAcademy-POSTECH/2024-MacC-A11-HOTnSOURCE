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
    @Binding var step: CreateLocationStep
    
    @State private var name: String = ""
    
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
            descriptionRow
            
            Spacer()
            
            nameInputRow
            
            Spacer()
            Spacer()
            
            NextStepButton(step: $step)
                .disabled(name.isEmpty)
        }
    }
    
    // MARK: SubViews
    private var descriptionRow: some View {
        VStack(spacing: 10) {
            Text("어떤 장소인가요?")
                .font(.title)
            Text("사용할 곳의 이름을 작성해주세요")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .fontWeight(.bold)
    }
    
    private var nameInputRow: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .trailing) {
                TextField("이름을 입력해주세요", text: $name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .onChange(of: name) { newValue in
                        if newValue.count > nameMaxLength {
                            name = String(newValue.prefix(nameMaxLength))
                        }
                    }
                
                Text("\(name.count)/\(nameMaxLength)")
                    .font(.callout)
                    .foregroundStyle(.tertiary)
            }
            
            Rectangle()
                .frame(height: 3)
                .foregroundStyle(.accent)
        }
    }
}

// MARK: - Preview
#Preview {
    NameInputView(step: .constant(.nameInput))
}
