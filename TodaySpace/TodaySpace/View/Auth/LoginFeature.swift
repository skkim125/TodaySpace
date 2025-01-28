//
//  LoginFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LoginFeature {
    
    enum ScenePhase {
        case onboarding
        case loginSuccess
    }
    
    @Dependency(\.userClient) var userClient
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var emailText: String = ""
        var passwordText: String = ""
        var buttonEnabled: Bool = false
        var showProgressView: Bool = false
        var scenePhase: ScenePhase = .onboarding
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case clickBackButton
        case buttonTap
        case loginSuccess(EmailLoginResponse)
        case loginFailure(Error)
    }
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                state.buttonEnabled = isEmailValid(state.emailText) && isPasswordValid(state.passwordText)
                return .none
                
            case .clickBackButton:
                return .none
                
            case .buttonTap:
                state.showProgressView = true
                
                return .run { [state] send in
                    let request = EmailLoginBody(email: state.emailText, password: state.passwordText)
                    do {
                        let result: EmailLoginResponse = try await userClient.emailLogin(request)
                        await send(.loginSuccess(result))
                    } catch {
                        await send(.loginFailure(error))
                    }
                }
                
            case .loginSuccess(let response):
                UserDefaultsManager.logIn(response.accessToken, response.refreshToken, response.user_id)
                print(UserDefaultsManager.accessToken)
                print(UserDefaultsManager.refreshToken)
                print(UserDefaultsManager.userID)
                state.showProgressView = false
                state.scenePhase = .loginSuccess
                return .none
                
            case .loginFailure(let error):
                state.showProgressView = false
                print(error)
                
                return .none
            }
        }
    }
    
    // 이메일 유효성 검증을 위한 함수
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
