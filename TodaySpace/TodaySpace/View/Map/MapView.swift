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
    let image: String?
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    private let networkManager = NetworkManager.shared
    
    @State private var posts: [PostResponse] = []
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedItem: String?
    @State private var mapState: MapState = .viewAppear
    @State private var currentRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.514575, longitude: 127.0495556),
        latitudinalMeters: 1500,
        longitudinalMeters: 1500
    )
    
    @Namespace var mapScope
    
    private var places: [Place] {
        posts.map {
            Place(
                id: $0.post_id,
                name: $0.content,
                image: $0.files?.first ?? "",
                coordinate: CLLocationCoordinate2D(
                    latitude: $0.geolocation.latitude,
                    longitude: $0.geolocation.longitude
                )
            )
        }
    }
    
    private var shouldShowSearchButton: Bool {
        mapState == .regionChanged
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            mapView()
            searchButton()
        }
        .onAppear(perform: startLocationServices)
        .onChange(of: locationManager.isInitialized) { _, initialized in
            if initialized,
               mapState == .viewAppear,
               let location = locationManager.currentLocation {
                setFirstLocation(location)
            }
        }
    }
    
    private func mapView() -> some View {
        Map(position: $position, selection: $selectedItem, scope: mapScope) {
            UserAnnotation()
            
            ForEach(places, id: \.id) { place in
                Annotation("", coordinate: place.coordinate) {
                    MapMarkerView(imageURL: place.image)
                }
                .tag(place.id)
            }
        }
        .tint(.black)
        .mapControlVisibility(.hidden)
        .onMapCameraChange { context in
            currentRegion = context.region
            if !position.followsUserLocation && mapState == .loaded {
                mapState = .regionChanged
            }
        }
    }
    
    private func searchButton() -> some View {
        VStack {
            if shouldShowSearchButton {
                Button {
                    searchPost(center: currentRegion.center)
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        
                        Text("이 주변 검색하기")
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
        .padding(.top, 35)
    }
}

extension MapView {
    private func startLocationServices() {
        if !locationManager.isInitialized {
            locationManager.startLocationServices()
        }
    }
    
    private func setFirstLocation(_ location: CLLocation) {
        position = .camera(MapCamera(
            centerCoordinate: location.coordinate,
            distance: 1500
        ))
        
        Task {
            await fetchAreaPosts(coordinate: location.coordinate)
            mapState = .loaded
        }
    }
    
    private func searchPost(center: CLLocationCoordinate2D) {
        mapState = .searching
        Task {
            await fetchAreaPosts(coordinate: center)
            mapState = .loaded
        }
    }
    
    private func fetchAreaPosts(coordinate: CLLocationCoordinate2D) async {
        let query = FetchAreaPostQuery(lat: coordinate.latitude, lon: coordinate.longitude)
        do {
            let data: FetchAreaPostResponse = try await networkManager.callRequest(
                targetType: PostTarget.fetchAreaPost(query)
            )
            posts = data.data
        } catch {
            print(error)
        }
    }
    
    private enum MapState {
        case viewAppear
        case loaded
        case regionChanged
        case searching
    }
}
