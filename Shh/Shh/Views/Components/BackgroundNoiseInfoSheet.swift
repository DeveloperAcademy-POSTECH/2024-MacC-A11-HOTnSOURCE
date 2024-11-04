//
//  BackgroundNoistInfoSheet.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/3/24.
//

import SwiftUI

struct BackgroundNoiseInfoSheet: View {
    let backgroundNoise: Float
    
    var body: some View {
        VStack {
            Spacer(minLength: 10)
            
            Text("배경 소음 예시")
            
            List {
                ForEach(Location.backgroundDecibelOptions, id: \.self) { decibel in
                    HStack(spacing: 20) {
                        Text("\(Int(decibel)) dB")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Text(Location.decibelWriting(decibel: decibel))
                            .foregroundStyle(decibel == backgroundNoise ? .accent : .customWhite)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
            }
        }
        .padding()
        .fontWeight(.bold)
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
    }
}

#Preview {
    BackgroundNoiseInfoSheet(backgroundNoise: 30.0)
}