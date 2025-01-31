//
//  WritePostFeature.swift
//  TodaySpace
//
//  Created by 김상규 on 1/29/25.
//

import SwiftUI
import MapKit
import PhotosUI
import ComposableArchitecture

@Reducer
struct WritePostFeature: Reducer {
    
    @Dependency(\.dismiss) var dismiss
    
    @Reducer
    enum Path {
        case addPlace(AddPlaceFeature)
    }
    
    @ObservableState
    struct State {
        // 뷰 전환
        var addPlace = AddPlaceFeature.State()
        var path = StackState<Path.State>()
        
        // 포스트 게시 내용
        var files: [String] = []
        var title: String = ""
        var placeInfo: PlaceInfo?
        var placeName: String = ""
        var longitude: Double = 0.0
        var latitude: Double = 0.0
        var category: String = ""
        var date: Date = Date()
        var dateString: String = ""
        var contents: String = ""
        var selectedItems: [PhotosPickerItem] = []
        var selectedImages: [UIImage] = []
        var selectedImageData: [Data] = []
        var isPickerPresented = false
        var showDatePicker = false
        
        // 버튼 활성화
        var buttonEnabled: Bool {
            !title.isEmpty && !placeName.isEmpty && !category.isEmpty && !dateString.isEmpty && !contents.isEmpty && !selectedImageData.isEmpty
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case addPhoto([PhotosPickerItem])
        case addPhotoResult([UIImage], [Data])
        case removePhoto(Int)
        case addPlaceButtonClicked
        case addPlace(AddPlaceFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case dismiss
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.addPlace, action: \.addPlace) {
            AddPlaceFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .addPhoto(let photos):
                return .run { send in
                    let result = await transformPhoto(photos)
                    await send(.addPhotoResult(result.images, result.data))
                }
                
            case .addPhotoResult(let images, let data):
                state.selectedImages = images
                state.selectedImageData = data
                state.isPickerPresented = false
                
                return .none
                
            case .removePhoto(let index):
                state.selectedItems.remove(at: index)
                state.selectedImages.remove(at: index)
                state.selectedImageData.remove(at: index)
                
                return .none
                
            case .addPlaceButtonClicked:
                state.path.append(.addPlace(AddPlaceFeature.State()))
                return .none
                
            case .addPlace:
                return .none
                
            case .path(.element(id: let id, action: .addPlace(.selectPlace(let place)))):
                state.placeInfo = place
                state.placeName = place.placeName
                state.latitude = Double(place.lat) ?? 0.0
                state.longitude = Double(place.lon) ?? 0.0
                print(state.placeName)
                print(state.latitude)
                print(state.longitude)
                
                state.path.pop(from: id)
                return .none
                
            case .path:
                return .none
            case .dismiss:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    func transformPhoto(_ items: [PhotosPickerItem]) async -> (images: [UIImage], data: [Data]) {
        var images: [UIImage] = []
        var data: [Data] = []
        
        for item in items {
            if let imageData = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: imageData) {
                images.append(image)
                data.append(imageData)
            }
        }
        
        return (images, data)
    }
}
