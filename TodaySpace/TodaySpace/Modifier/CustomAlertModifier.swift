//
//  CustomAlertModifier.swift
//  TodaySpace
//
//  Created by 김상규 on 2/3/25.
//

import SwiftUI

extension View {
    func showCustomAlert(isPresented: Binding<Bool>,
                     title: String,
                     message: String? = nil,
                     buttonTitle: String,
                     image: String? = nil,
                     action: (() -> Void)? = nil
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomAlert(isPresented: isPresented, title: title, message: message ?? "", buttonTitle: buttonTitle, image: image) {
                    action?()
                }
                .transition(.opacity)
            }
        }
    }
}
