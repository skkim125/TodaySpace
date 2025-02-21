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
    let frame: SetFrame
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } else if loadError {
                Text("이미지를 불러올 수 없습니다.")
            } else {
                EmptyView()
            }
        }
        .setFrame(setFrame: frame)
        .shadow(radius: 2)
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
