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
        var title: String?
        var contents: String?
        var coordinate: CLLocationCoordinate2D?
        var files: String?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
