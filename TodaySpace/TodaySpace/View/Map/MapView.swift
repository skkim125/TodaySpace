//
//  MapView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct PlaceCategory: Identifiable {
    let id: String
    let image: String
    let name: String
}

enum Category: String, CaseIterable {
    case restaurant = "식당"
    case cafe = "카페"
    case landmark = "명소"
    case shopping = "쇼핑"
}

struct MapView: View {
    private let locationManager = LocationManager()
    var categories: [PlaceCategory] = [
        PlaceCategory(id: "식당", image: "fork.knife", name: "식당"),
        PlaceCategory(id: "카페", image: "cup.and.saucer.fill", name: "카페"),
        PlaceCategory(id: "명소", image: "building.columns.fill", name: "명소"),
        PlaceCategory(id: "쇼핑", image: "cart.fill", name: "쇼핑")
    ]
    var places: [Place] = []
    @State private var selectedCategoryID: String?
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedItem: String?
    @State private var isChangeRegion: Bool = false
    @Namespace var mapScope
    
    private var selectedPlace: Place? {
        if let selectedItem {
            return places.first(where: { $0.id.hashValue == selectedItem.hashValue })
        }
        return nil
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack {
                Group {
                    Map(position: $position, selection: $selectedItem, scope: mapScope) {
                        UserAnnotation()
                        
                        ForEach(places, id: \.id) { place in
                            Annotation("", coordinate: place.coordinate) {
                                MapMarker()
                            }
                            .tag(place.id)
                        }
                    }
                    .tint(Color.accentColor)
                    .onMapCameraChange { context in
                        if !position.followsUserLocation {
                            isChangeRegion = true
                        }
                    }
                    .onChange(of: selectedItem) { _, newValue in
                        if let place = places.first(where: { $0.id == newValue }) {
                            withAnimation(.easeIn) {
                                position = .camera(MapCamera(centerCoordinate: place.coordinate, distance: 1800))
                            }
                        }
                    }
                    .onReceive(locationManager.$myLocation) { location in
                        if let location = location {
                            withAnimation {
                                position = .camera(MapCamera(
                                    centerCoordinate: location,
                                    distance: 1800
                                ))
                            }
                        }
                    }
                }
            }
            
            Group {
                VStack {
                    HStack(alignment: .center, spacing: 20) {
                        ForEach(categories, id: \.id) { category in
                            HStack {
                                HStack(spacing: 10) {
                                    Image(systemName: category.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15, height: 15)
                                    
                                    Text(category.name)
                                        .font(.system(size: 15))
                                }
                                .frame(height: 20)
                                .foregroundStyle(category.id == selectedCategoryID ? .white : .black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(category.id == selectedCategoryID ? Color.gray : Color.white)
                                        .animation(.easeInOut(duration: 0.2), value: selectedCategoryID)
                                        .onTapGesture {
                                            selectedCategoryID = (selectedCategoryID == category.id) ? nil : category.id
                                            isChangeRegion = false
                                        }
                                        .shadow(radius: 0.5)
                                }
                            }
                        }
                    }
                    
                    if isChangeRegion {
                        Button {
                            locationManager.locationUpdate()
                            isChangeRegion = false
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                
                                Text("재검색하기")
                                    .font(.system(size: 14))
                            }
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background {
                                Capsule()
                                    .fill(Color.orange)
                                    .shadow(radius: 1)
                            }
                        }
                        .padding(.top)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }
}
