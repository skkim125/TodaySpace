//
//  PostTarget.swift
//  TodaySpace
//
//  Created by 김상규 on 1/26/25.
//

import Foundation

enum PostTarget {
    case uploadImage(ImageUploadBody)
    case postUpload(PostBody)
    case fetchPost(FetchPostQuery)
    case fetchAreaPost(FetchAreaPostQuery)
}

extension PostTarget: TargetType {
    var baseURL: String {
        return API.baseURL + "/v1"
    }
    
    var header: [String : String] {
        switch self {
        case .uploadImage(let body):
            let contentType = ContentType.multpartform + "; boundary=\(body.boundary)"
            return [
                Header.contentType: contentType,
                Header.productId: API.productId,
                Header.authorization: UserDefaultsManager.accessToken,
                Header.sesacKey: API.apiKey,
            ]
            
        case .postUpload:
            return [
                Header.contentType: ContentType.json,
                Header.productId: API.productId,
                Header.authorization: UserDefaultsManager.accessToken,
                Header.sesacKey: API.apiKey,
            ]
        case .fetchPost:
            return [
                Header.productId: API.productId,
                Header.authorization: UserDefaultsManager.accessToken,
                Header.sesacKey: API.apiKey,
            ]
        case .fetchAreaPost:
            return [
                Header.productId: API.productId,
                Header.authorization: UserDefaultsManager.accessToken,
                Header.sesacKey: API.apiKey,
            ]
        }
    }
    
    var path: String? {
        switch self {
        case .uploadImage:
            return "posts/files"
        case .postUpload:
            return "posts"
        case .fetchPost:
            return "posts"
        case .fetchAreaPost:
            return "posts/geolocation"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImage, .postUpload:
            return .post
        case .fetchPost:
            return .get
        case .fetchAreaPost:
            return .get
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .fetchPost(let postQuery):
            var queries = [URLQueryItem]()
            queries.append(URLQueryItem(name: "next", value: postQuery.next))
            queries.append(URLQueryItem(name: "limit", value: postQuery.limit))
            
            let categories = postQuery.category.map{ URLQueryItem(name: "category", value: $0) }
            queries.append(contentsOf: categories)
            return queries
        case .fetchAreaPost(let postQuery):
            var queries = [URLQueryItem]()
            queries.append(URLQueryItem(name: "latitude", value: postQuery.latitude))
            queries.append(URLQueryItem(name: "longitude", value: postQuery.longitude))
            queries.append(URLQueryItem(name: "maxDistance", value: "1500"))
            
            let categories = postQuery.category.map{ URLQueryItem(name: "category", value: $0) }
            queries.append(contentsOf: categories)
            
            return queries
        default:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .uploadImage(let body):
            let fileName = API.productId + "Post_Image"
            return convertMultipartFormData(boundary: body.boundary, datas: body.files, filename: fileName)
            
        case .postUpload(let body):
            do {
                let data = try encoder.encode(body)
                return data
            } catch {
                print("Body to JSON Encode Error", error)
                return nil
            }
            
        default:
            return nil
        }
    }
}
