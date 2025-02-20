//
//  MapViewState.swift
//  TodaySpace
//
//  Created by 김상규 on 2/19/25.
//

import SwiftUI
import MapKit
import ComposableArchitecture

@Reducer
struct MapViewFeature {
    
    @Dependency(\.postClient) var postClient
    
    @ObservableState
    struct State {
        let locationManager = LocationManager()
        var posts: [PostResponse] = []
        var position: MapCameraPosition = .automatic
        var mapState: MapState = .viewAppear
        var currentRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.514575, longitude: 127.0495556),
            latitudinalMeters: 1500,
            longitudinalMeters: 1500
        )
        var showInfoSheet = false
        var selectedItem: Place?
        var places: [Place] {
            posts.map {
                Place(
                    id: $0.post_id,
                    name: $0.content1,
                    address: $0.content2,
                    postTitle: $0.title,
                    image: $0.files?.first ?? "",
                    lat: $0.geolocation.latitude,
                    lon: $0.geolocation.longitude,
                    distance: $0.distance
                )
            }
        }
        
        var showSearchButton: Bool {
            self.mapState == .regionChanged
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case checkLocationAuthorization
        case setInitialPosition(Bool)
        case fetchCurrrentRegion(MKCoordinateRegion)
        case searchButtonTapped
        case selectedPlace(Place?)
        case searchPost(CLLocationCoordinate2D)
        case searchSuccess([PostResponse])
        case searchFailure(Error)
        case goPostDetail
        case postDetail(PostResponse)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .checkLocationAuthorization:
                if !state.locationManager.isInitialized {
                    state.locationManager.startLocationServices()
                }
                return .none
            case .setInitialPosition(let initialized):
                if initialized,
                   state.mapState == .viewAppear,
                   let location = state.locationManager.currentLocation {
                    state.position = .camera(MapCamera(
                        centerCoordinate: location.coordinate,
                        distance: 1500
                    ))
                    state.mapState = .searching
                    return .run { send in
                        return await send(.searchPost(location.coordinate))
                    }
                }
                return .none
                
            case .searchPost(let coordinate):
                let query = FetchAreaPostQuery(lat: coordinate.latitude, lon: coordinate.longitude)
                
                return .run { send in
                    do {
                        let result: FetchAreaPostResponse = try await postClient.fetchAreaPost(query)
                        await send(.searchSuccess(result.data))
                    } catch {
                        await send(.searchFailure(error))
                    }
                }
                
            case .searchSuccess(let posts):
                state.posts = posts
                state.mapState = .loaded
                return .none
                
            case .searchFailure(let error):
                state.mapState = .loaded
                print(error)
                return .none
                
            case .searchButtonTapped:
                let region = state.currentRegion.center
                
                return .run { send in
                    return await send(.searchPost(region))
                }
                
            case .selectedPlace(let place):
                if let place = place {
                    state.selectedItem = place
                    state.position = .camera(MapCamera(
                        centerCoordinate: place.coordinate,
                        distance: 1500
                    ))
                    
                    return .none
                }
                return .none
                
            case .fetchCurrrentRegion(let region):
                state.currentRegion = region
                if !state.position.followsUserLocation && state.mapState == .loaded {
                    state.mapState = .regionChanged
                }
                return .none
                
            case .goPostDetail:
                if let place = state.selectedItem, let post = state.posts.first(where: { $0.post_id == place.id }) {
                    return .send(.postDetail(post))
                } else {
                    return .none
                }
                
            case .postDetail:
                return .none
            }
        }
    }
    
    enum MapState {
        case viewAppear
        case loaded
        case regionChanged
        case searching
    }
}
