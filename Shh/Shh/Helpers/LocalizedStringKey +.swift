//
//  LocalizedStringKey+.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/16/24.
//

import SwiftUI

extension LocalizedStringKey {
    func toString(locale: Locale = .current) -> String {
        let mirror = Mirror(reflecting: self)
        if let key = mirror.children.first(where: { $0.label == "key" })?.value as? String {
            return NSLocalizedString(key, comment: "")
        }
        return ""
    }
}
