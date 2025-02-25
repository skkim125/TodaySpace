//
//  CustomAlert.swift
//  TodaySpace
//
//  Created by 김상규 on 2/3/25.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let buttonTitle: String
    let image: String?
    var action: (() -> Void)?
    @State private var opacity: Double = 0
    @State private var backgroundOpacity: Double = 0
    
    var body: some View {
        ZStack {
            if isPresented {
                AppColor.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            
            VStack(spacing: 16) {
                if let image = image {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .foregroundStyle(AppColor.white)
                        .opacity(0.8)
                }
                
                VStack(spacing: 6) {
                    Text(title)
                        .appFontBold(size: 20)
                        .foregroundStyle(AppColor.white)
                        .multilineTextAlignment(.center)
                    
                    if let message = message {
                        Text(message)
                            .appFontLight(size: 16)
                            .foregroundStyle(AppColor.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal)
                
                Button {
                    dismissAlert()
                } label: {
                    Text(buttonTitle)
                        .asRoundButton(foregroundColor: AppColor.black, backgroundColor: AppColor.white)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: 270)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppColor.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AppColor.black, lineWidth: 1)
                    )
                    .shadow(color: AppColor.black.opacity(0.1), radius: 20, x: 10, y: 10)
            )
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.3)) {
                    opacity = 1
                }
            }
        }
        .zIndex(10)
    }
    
    private func dismissAlert() {
        
        withAnimation(.easeInOut(duration: 0.2)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            action?()
            isPresented = false
        }
    }
}
