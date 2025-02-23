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
            VStack {
                VStack(spacing: 10) {
                    ZStack(alignment: .leading) {
                        TextField(
                            "",
                            text: $store.emailText
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .font(.system(size: 16))
                        .keyboardType(.twitter)
                        .textFieldStyle(.roundedBorder)
                        
                        if store.emailText.isEmpty {
                            Text("example@example.com")
                                .font(.system(size: 16))
                                .fontWeight(.regular)
                                .tint(Color(uiColor: .placeholderText))
                                .padding(.leading, 7)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    SecureField("6자리 이상 입력해주세요", text: $store.passwordText)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 16))
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                logInButton()
                    .padding(.horizontal, 20)
                    .padding(.bottom)
            }
            .padding(.top)
            
            if store.showProgressView {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(uiColor: .lightGray.withAlphaComponent(0.2)))
                    .frame(width: 50, height: 50)
                    .overlay {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .showCustomAlert(isPresented: $store.showLoginSuccessAlert, title: store.alertTitle, buttonTitle: "확인") {
            store.send(.loginSuccessConfirmButtonClicked)
        }
        .showCustomAlert(isPresented: $store.showLoginFailureAlert, title: store.alertTitle, message: store.alertMessage, buttonTitle: "확인") {
            store.send(.loginFailureConfirmButtonClicked)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.clickBackButton)
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                        Text("뒤로가기")
                    }
                }
                .tint(Color(uiColor: .label))
            }
        }
    }
    
    @ViewBuilder
    private func logInButton() -> some View {
        if store.buttonEnabled {
            Button {
                store.send(.buttonTap)
            } label: {
                RoundedButton(text: "로그인",
                              foregroundColor: .white,
                              backgroundColor: .yellow)
            }
        } else {
            RoundedButton(text: "로그인",
                          foregroundColor: .white,
                          backgroundColor: .gray)
        }
    }
}
