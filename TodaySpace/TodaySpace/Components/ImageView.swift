//
//  ImageView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/12/25.
//

import SwiftUI

struct ImageView: View {
    let imageURL: String?
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var loadError = false
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
            } else if loadError {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
            } else {
                EmptyView()
            }
        }
        .task {
            await loadImage()
        }
    }
}

extension ImageView {
    private func loadImage() async {
        guard let postImage = imageURL, !postImage.isEmpty else {
            loadError = true
            return
        }
        
        isLoading = true
        
        do {
            image = try await NetworkManager.shared.fetchImage(imageURL: postImage)
        } catch {
            print("이미지 로드 실패: \(error)")
            loadError = true
        }
        
        isLoading = false
    }
}
