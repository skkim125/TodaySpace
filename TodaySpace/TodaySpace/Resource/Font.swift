//
//  Font.swift
//  TodaySpace
//
//  Created by 김상규 on 2/25/25.
//

import SwiftUI

extension View {
    func appFontLight(size: CGFloat) -> some View {
        self.font(.custom("BookkGothicOTF-Lt", size: size))
            .lineSpacing(5)
    }

    func appFontBold(size: CGFloat) -> some View {
        self.font(.custom("BookkGothicOTF-Bd", size: size))
            .lineSpacing(5)
    }
}

