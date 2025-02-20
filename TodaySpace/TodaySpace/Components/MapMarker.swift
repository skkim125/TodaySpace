//
//  MapMarker.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import MapKit

struct MapMarkerView: View {
    let imageURL: String?
    
    var body: some View {
        VStack {
            Circle()
                .fill(AppColor.appBackground)
                .frame(width: 50, height: 50)
                .overlay {
                    ImageView(imageURL: imageURL, frame: .auto)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                }
        }
    }
}
