//
//  Triangle.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // 왼쪽 상단
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // 중앙 하단
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // 오른쪽 상단
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // 왼쪽 상단 (닫힌 경로)
        }
    }
}
