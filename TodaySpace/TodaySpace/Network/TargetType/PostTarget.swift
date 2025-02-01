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
        }
    }
    
    var path: String? {
        switch self {
        case .uploadImage:
            return "posts/files"
        case .postUpload:
            return "posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImage, .postUpload:
            return .post
        }
    }
    
    var query: [URLQueryItem]? {
        return nil
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
        }
    }
}

extension PostTarget {
    func convertMultipartFormData(boundary: String, datas: [Data], filename: String) -> Data {
        let crlf = "\r\n"
        let data = NSMutableData()
        
        datas.forEach {
            data.append("--\(boundary)\(crlf)".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(filename)\"\(crlf)".data(using: .utf8)!)
            data.append("Content-Type: image/png\(crlf)\(crlf)".data(using: .utf8)!)
            data.append($0)
            data.append("\(crlf)".data(using: .utf8)!)
        }
        data.append("--\(boundary)--\(crlf)".data(using: .utf8)!)
        
        return data as Data
    }
}
