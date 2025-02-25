//
//  FiledBackgroundModifier.swift
//  TodaySpace
//
//  Created by 김상규 on 2/25/25.
//

import SwiftUI

extension View {
    func fieldBackground() -> some View {
        self
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppColor.appSecondary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(AppColor.grayStroke, lineWidth: 1)
            )
            .appFontLight(size: 15)
    }
}
