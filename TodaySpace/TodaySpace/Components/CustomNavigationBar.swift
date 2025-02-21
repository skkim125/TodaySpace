//
//  CustomNavigationBar.swift
//  TodaySpace
//
//  Created by 김상규 on 2/20/25.
//

import SwiftUI

struct CustomNavigationBar<C, L, R>: ViewModifier where C: View, L: View, R: View {
    var centerView: (() -> C)?
    let leftView: (() -> L)?
    let rightView: (() -> R)?
    
    init(
        centerView: (() -> C)? = nil,
        leftView: (() -> L)? = nil ,
        rightView: (() -> R)? = nil
    ) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
    }
    
    func body(content: Content) -> some View {
        
        VStack {
            ZStack {
                HStack {
                    leftView?()
                    
                    Spacer()
                    
                    rightView?()
                }
                
                HStack {
                    centerView?()
                }
            }
            .padding(.horizontal)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            content
        }
        .background(AppColor.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}
