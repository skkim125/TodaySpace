//
//  ImageCacher.swift
//  TodaySpace
//
//  Created by 김상규 on 2/23/25.
//

import SwiftUI
import Accelerate.vImage

final class ImageCacher {
    static let shared = ImageCacher()
    private init() {}

    private let cache: NSCache<NSString, UIImage> = {
       let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 1024 * 1024 * 50
        
        return cache
    }()

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func insertImage(_ image: UIImage?, forKey key: String) {
        guard let image = image else {
            removeImage(forKey: key)
            return
        }
        cache.setObject(image, forKey: key as NSString)
    }

    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
