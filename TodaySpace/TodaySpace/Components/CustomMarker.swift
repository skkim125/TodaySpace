//
//  CustomMarker.swift
//  TodaySpace
//
//  Created by 김상규 on 2/27/25.
//

import SwiftUI

struct CustomMarkerView: View {
    var placeName: String

    var body: some View {
        VStack(spacing: 0) {
            Text(placeName)
                .appFontBold(size: 12)
                .foregroundStyle(AppColor.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColor.appBackground)
                        .stroke(AppColor.appGold, lineWidth: 1)
                }
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Triangle()
                .fill(AppColor.appGold)
                .frame(width: 10, height: 7)
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
