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
                .fill(Color.black)
                .frame(width: 60, height: 60)
                .overlay {
                    ImageView(imageURL: imageURL, frame: .auto)
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                }
        }
        .foregroundStyle(.black)
    }
}
