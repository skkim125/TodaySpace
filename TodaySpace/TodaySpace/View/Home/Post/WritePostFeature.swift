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
        var buttonEnabled: Bool {
            !title.isEmpty && !placeName.isEmpty && !category.isEmpty && !date.isEmpty && !contents.isEmpty
        }
        var selectedItems: [PhotosPickerItem] = []
        var selectedImages: [UIImage] = []
        var selectedImageData: [Data] = []
        var isPickerPresented = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case addPhoto([PhotosPickerItem])
        case addPhotoResult([UIImage], [Data])
        case removePhoto(Int)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
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
            }
        }
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
