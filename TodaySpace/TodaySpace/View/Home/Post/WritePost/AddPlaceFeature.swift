//
//  AddPlaceFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/31/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AddPlaceFeature: Reducer {

    @Dependency(\.kakaoLocalClient) var kakaoLocalClient
    
    @ObservableState
    struct State {
        var searchText = ""
        var results: [PlaceInfo] = []
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case searchButtonTapped
        case searchSuccess([PlaceInfo])
        case searchError(Error)
        case selectPlace(PlaceInfo)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .searchButtonTapped:
                let query = state.searchText
                return .run { send in
                    do {
                        let data = try await kakaoLocalClient.searchPlace(query)
                        let results = data.results
                        await send(.searchSuccess(results))
                    } catch {
                        await send(.searchError(error))
                    }
                }
            case .searchSuccess(let results):
                state.results = results
                return .none
            case .searchError(let error):
                if let error = error as? ErrorType {
                    print(error.message)
                } else if let error = error as? NetworkError {
                    print(error.errorDescription)
                }
                return .none
            case .selectPlace:
                return .none
            }
        }
    }
    
}

