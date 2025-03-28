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
            
            VStack(spacing: 0) {
                Spacer()
                
                if let image = image {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .foregroundStyle(AppColor.white)
                        .opacity(0.8)
                        .padding(.top, 10)
                }
                
                VStack(spacing: 10) {
                    Text(title)
                        .appFontBold(size: 18)
                        .foregroundStyle(AppColor.white)
                        .multilineTextAlignment(.center)
                    
                    if let message = message {
                        Text(message)
                            .appFontLight(size: 14)
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
                .padding(.vertical, 10)
            }
            .frame(maxWidth: 300, maxHeight: 120)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColor.appSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.appGold, lineWidth: 0.5)
                    )
                    .shadow(color: AppColor.appSecondary, radius: 20, x: 10, y: 10)
            }
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
