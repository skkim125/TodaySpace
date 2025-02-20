//
//  PlaceCardView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/16/25.
//

import SwiftUI

struct PlaceCardView: View {
    let place: Place
    var onDismiss: () -> Void
    private let width = UIScreen.main.bounds.width * 0.9
    private let height = UIScreen.main.bounds.height * 0.2
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .center) {
                ImageView(
                    imageURL: place.image,
                    frame: .setFrame(
                        height - 30,
                        height - 30
                    )
                )
                .padding(.leading, 15)

                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.title2).bold()
                        .lineLimit(1)
                        .foregroundStyle(Color(.label))
                    
                    Text(place.postTitle)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundStyle(Color(.label))
                    
                    if let distance = place.distance {
                        Text(distance.decimalString)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
            }
            .padding(.vertical, 20)

            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onDismiss()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .tint(.gray)
            .padding(15)
        }
        .frame(width: width, height: height)
        .background(AppColor.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 5)
    }
}

extension Double {
    var decimalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let distanceStr = formatter.string(from: NSNumber(value: Int(self))) {
            return distanceStr + "m"
        } else {
            return ""
        }
    }
}

