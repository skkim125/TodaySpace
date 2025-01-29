//
//  WritePostFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/29/25.
//

import Foundation
import MapKit
import ComposableArchitecture

struct WritePostFeature: Reducer {
    
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State {
        var files: [String] = []
        var title: String = ""
        var placeName: String = ""
        var longitude: Double = 0.0
        var latitude: Double = 0.0
        var category: String = ""
        var date: String = ""
        var contents: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
