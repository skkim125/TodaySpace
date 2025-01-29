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

struct MapView: View {
    private let locationManager = LocationManager()
    var places: [Place] = []
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedItem: String?
    @State private var isChangeRegion: Bool = false
    @State private var currentCenterRegion: CLLocationCoordinate2D?
    @State private var isInitialLocationSet: Bool = false
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
                    .tint(Color.black)
                    .mapControlVisibility(.hidden)
                    .onMapCameraChange { context in
                        if !position.followsUserLocation && isInitialLocationSet {
                            isChangeRegion = true
                        }
                        
                        currentCenterRegion = context.region.center
                    }
                    .onChange(of: selectedItem) { _, newValue in
                        if let place = places.first(where: { $0.id == newValue }) {
                            withAnimation(.easeIn) {
                                position = .camera(MapCamera(centerCoordinate: place.coordinate, distance: 1800))
                            }
                        }
                    }
                    .onReceive(locationManager.$myLocation) { _ in
                        withAnimation {
                            position = .userLocation(followsHeading: true, fallback: .automatic)
                            
                            if !isInitialLocationSet {
                                isInitialLocationSet = true
                            }
                        }
                    }
                }
            }
            
            Group {
                VStack {
                    
                    if isChangeRegion {
                        Button {
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
