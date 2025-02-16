//
//  PlaceCardView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/16/25.
//

import SwiftUI

struct PlaceCardView: View {
    let place: Place
    var body: some View {
        HStack(spacing: 20) {
            ImageView(imageURL: place.image, frame: .auto)
                .frame(width: 100, height: 100)
                .padding(.all, 15)
                .padding(.leading)
            
            Text(place.name)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.trailing)
        }
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}
