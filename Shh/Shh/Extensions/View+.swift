//
//  View+.swift
//  Shh
//
//  Created by sseungwonnn on 10/31/24.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
