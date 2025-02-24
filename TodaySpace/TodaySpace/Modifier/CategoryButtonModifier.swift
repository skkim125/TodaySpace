//
//  CategoryButtonModifier.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI

extension View {
    func roundCategoryView(
        title: String,
        titleFontSize: CGFloat = 14,
        image: String? = nil,
        foregroundColor: Color,
        backgroundColor: Color,
        strokeColor: Color = .clear,
        strokeLineWidth: CGFloat = 0,
        action: (() -> Void)? = nil
    ) -> some View {
        HStack(spacing: 5) {
            if let image = image {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
            }
            
            Text(title)
                .font(.system(size: titleFontSize))
        }
        .bold()
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .foregroundStyle(foregroundColor)
        .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(strokeColor, lineWidth: strokeLineWidth)
        )
        .onTapGesture {
            action?()
        }
    }
}
