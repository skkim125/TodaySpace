//
//  LoginView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                Text("Today Space")
                    .appFontBold(size: 28).bold()
                    .fontDesign(.serif)
                    .foregroundStyle(AppColor.appGold)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 20) {
                    FloatingPlaceholderTextField(placeholder: "이메일", text: $store.emailText)
                    
                    FloatingPlaceholderTextField(placeholder: "비밀번호", text: $store.passwordText, isSecure: true)
                }
                .padding(.horizontal, 25)
                
                logInButton()
                    .padding(.horizontal, 20)
            }
            .padding(.top)
            
            if store.showProgressView {
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppColor.grayStroke)
                    .frame(width: 50, height: 50)
                    .overlay {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.appBackground)
        .showCustomAlert(isPresented: $store.showLoginSuccessAlert, title: store.alertTitle, buttonTitle: "확인") {
            store.send(.loginSuccessConfirmButtonClicked)
        }
        .showCustomAlert(isPresented: $store.showLoginFailureAlert, title: store.alertTitle, message: store.alertMessage, buttonTitle: "확인") {
            store.send(.loginFailureConfirmButtonClicked)
        }
    }
    
    @ViewBuilder
    private func logInButton() -> some View {
        if store.buttonEnabled {
            Button {
                store.send(.buttonTap)
            } label: {
                RoundedButton(text: "로그인",
                              foregroundColor: AppColor.white,
                              backgroundColor: AppColor.appGold)
            }
        } else {
            RoundedButton(text: "로그인",
                          foregroundColor: AppColor.white,
                          backgroundColor: AppColor.gray)
        }
    }
}
