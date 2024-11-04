//
//  DistanceInputField.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/4/24.
//

import SwiftUI

struct DistanceInputField: View {
    @Binding var distance: Float
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(distance, specifier: "%.1f") m")
                .font(.title)
            
            Text("정도 떨어져 있어요")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Spacer().frame(height: 22)
            
            SliderWithSnap(distance: $distance, snapPoints: [1.0, 1.5, 2.0, 2.5, 3.0])
            
            Spacer().frame(height: 5)
            
            HStack {
                Text("1m")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("2m")
                    .frame(maxWidth: .infinity)
                Text("3m")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .fontWeight(.bold)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.tertiary)
        }
    }
}
