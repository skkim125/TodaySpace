//
//  CategoryButtonModifier.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI

extension View {
    func categoryButton<T: Equatable>(
        title: String,
        image: String? = nil,
        foregroundColor: Color,
        backgroundColor: Color,
        animationValue: T,
        action: @escaping (() -> Void)
    ) -> some View {
        HStack {
            HStack(spacing: 10) {
                if let image = image {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
                
                Text(title)
                    .font(.system(size: 12))
            }
            .frame(height: 20)
            .foregroundStyle(
                foregroundColor
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppColor.main, lineWidth: 0.7)
                    .fill(backgroundColor)
                    .animation(.easeInOut(duration: 0.2), value: animationValue)
            )
        }
        .onTapGesture {
            action()
        }
    }
}
