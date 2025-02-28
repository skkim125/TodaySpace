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
    
    enum Field: Hashable {
        case email
        case password
    }
    
    @FocusState private var focusField: Field?
    
    var body: some View {
        ZStack {
            AppColor.appBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    focusField = nil
                }
            
            VStack(spacing: 40) {
                Text("Today Space")
                    .appFontBold(size: 28).bold()
                    .fontDesign(.serif)
                    .foregroundStyle(AppColor.appGold)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 20) {
                    FloatingPlaceholderTextField(placeholder: "이메일", text: $store.emailText, focusField: $focusField, field: .email)
                    
                    FloatingPlaceholderTextField(placeholder: "비밀번호", text: $store.passwordText, isSecure: true, focusField: $focusField, field: .password)
                }
                
                logInButton()
            }
            .padding(.top)
            .padding(.horizontal, 25)
            
            if store.showProgressView {
                CustomProgressView()
            }
        }
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
