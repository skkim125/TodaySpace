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
        
        var showLoginSuccessAlert: Bool = false
        var showLoginFailureAlert: Bool = false
        var alertTitle: String = ""
        var alertMessage: String?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case clickBackButton
        case buttonTap
        case loginSuccess(EmailLoginResponse)
        case loginFailure(Error)
        case loginSuccessConfirmButtonClicked
        case loginFailureConfirmButtonClicked
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
                print("액세스 토큰", UserDefaultsManager.accessToken)
                print("리프레시 토큰", UserDefaultsManager.refreshToken)
                print("유저 아이디", UserDefaultsManager.userID)
                state.showProgressView = false
                state.alertTitle = "로그인되었습니다."
                state.showLoginSuccessAlert = true
                
                return .none
                
            case .loginFailure(let error):
                if let error = error as? ErrorType {
                    print(error.message)
                    state.alertTitle = "로그인에 실패했습니다."
                    state.alertMessage = "이메일 및 비밀번호를 다시 입력하세요"
                } else if let error = error as? NetworkError {
                    state.alertTitle = "서버에 연결할 수 없습니다."
                    state.alertMessage = "잠시후 다시 시도해주세요"
                    print(error.errorDescription)
                }
                
                state.showProgressView = false
                state.showLoginFailureAlert = true
                
                return .none
            
            case .loginSuccessConfirmButtonClicked:
                state.scenePhase = .loginSuccess
                return .none
                
            case .loginFailureConfirmButtonClicked:
                
                return .none
            }
        }
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
