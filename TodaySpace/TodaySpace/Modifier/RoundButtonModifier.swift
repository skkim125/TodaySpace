//
//  RoundButtonModifier.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI

extension View {
    func asRoundButton(foregroundColor: Color,
                       backgroundColor: Color
    ) -> some View {
        self
            .font(.title3)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(uiColor: .placeholderText), lineWidth: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
