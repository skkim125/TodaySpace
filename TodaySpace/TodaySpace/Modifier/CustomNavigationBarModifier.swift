//
//  CustomNavigationBarModifier.swift
//  TodaySpace
//
//  Created by 김상규 on 2/20/25.
//

import SwiftUI

extension View {
    func customNavigationBar<C, L, R>(
        centerView: @escaping () -> C,
        leftView: @escaping () -> L,
        rightView:  @escaping () -> R
    ) -> some View where C: View, L: View, R: View {
        modifier(
            CustomNavigationBar(centerView: centerView, leftView: leftView, rightView: rightView)
        )
    }
}
