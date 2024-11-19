//
//  SsambbongAsset.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

struct SsambbongAsset: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(minHeight: 150, maxHeight: 200)
            .frame(maxHeight: 250, alignment: .top)
    }
}

#Preview {
//    SsambbongAsset(image: .backgroundNoiseInputAsset)
}
