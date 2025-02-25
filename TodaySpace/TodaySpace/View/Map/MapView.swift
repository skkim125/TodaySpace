//
//  MapView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct Place: Identifiable, Hashable {
    let id: String
    let name: String
    let address: String
    let postTitle: String
    let image: String?
    let lat: Double
    let lon: Double
    let distance: Double?
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: lat, longitude: lon)
    }
}

struct MapView: View {
    @Bindable var store: StoreOf<MapViewFeature>
    @Namespace var mapScope
    
    var body: some View {
        ZStack(alignment: .center) {
            mapView()
            searchButton()
            
            if let place = store.selectedItem {
                placeCardView(place: place)
            }
        }
        .onAppear {
            store.send(.checkLocationAuthorization)
        }
        .onReceive(store.locationManager.$isInitialized.removeDuplicates()){ isInitialized in
            store.send(.setInitialPosition(isInitialized))
        }
    }
    
    private func mapView() -> some View {
        Map(position: $store.position, scope: mapScope) {
            UserAnnotation()
            
            ForEach(store.places, id: \.id) { place in
                Annotation("", coordinate: place.coordinate) {
                    MapMarkerView(imageURL: place.image)
                        .onTapGesture {
                            store.send(.selectedPlace(place), animation: .easeInOut(duration: 0.3))
                        }
                }
                .tag(place)
            }
        }
        .tint(AppColor.black)
        .mapControlVisibility(.hidden)
        .onMapCameraChange { context in
            store.send(.fetchCurrrentRegion(context.region))
        }
    }
    
    private func searchButton() -> some View {
        VStack {
            if store.showSearchButton {
                Button {
                    store.send(.searchButtonTapped)
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        
                        Text("이 주변 검색하기")
                            .appFontLight(size: 14)
                    }
                    .foregroundStyle(AppColor.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background {
                        Capsule()
                            .fill(Color.appGold)
                            .shadow(radius: 1)
                    }
                }
                .padding(.top, 10)
            }
            Spacer()
        }
    }
    
    func placeCardView(place: Place) -> some View {
        ZStack {
            VStack {
                Spacer()
                
                PlaceCardView(place: place) {
                    store.send(.selectedPlace(nil))
                }
                .transition(.move(edge: .bottom))
                .padding(.bottom, 30)
                .onTapGesture {
                    store.send(.goPostDetail)
                }
            }
        }
    }
}
