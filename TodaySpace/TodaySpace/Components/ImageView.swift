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
    let frame: SetFrame
    let errorImage: Image
    
    var body: some View {
        ZStack {
            if isLoading {
                CustomProgressView()
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } else {
                errorImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .setFrame(setFrame: frame)
        .shadow(radius: 2)
        .onChange(of: imageURL) { _, newValue in
            if let image = newValue, !image.isEmpty {
                Task {
                    await loadImage()
                }
            }
        }
        .onAppear {
            Task {
                await loadImage()
            }
        }
    }
}

extension ImageView {
    private func loadImage() async {
        guard let postImage = imageURL, !postImage.isEmpty else {
            return
        }
        
        isLoading = true
        
        do {
            image = try await NetworkManager.shared.fetchImage(imageURL: postImage)
        } catch {
            print("이미지 로드 실패: \(error)")
            return
        }
        
        isLoading = false
    }
}

enum SetFrame {
    case auto
    case setFrame(CGFloat, CGFloat)
}

extension View {
    
    @ViewBuilder
    func setFrame(setFrame: SetFrame) -> some View {
        switch setFrame {
        case .auto:
            self
        case .setFrame(let width, let height):
            self.frame(width: width, height: height)
        }
    }
}
