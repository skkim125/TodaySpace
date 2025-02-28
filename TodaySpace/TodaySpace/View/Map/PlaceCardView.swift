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
                        height - 40,
                        height - 40
                    ),
                    errorImage: Image("exclamationmark.triangle.fill")
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, 15)

                VStack(alignment: .leading, spacing: 10) {
                    Text(place.name)
                        .appFontBold(size: 20)
                        .lineLimit(1)
                        .foregroundStyle(Color(.label))
                    
                    Text(place.postTitle)
                        .appFontBold(size: 18)
                        .lineLimit(1)
                        .foregroundStyle(Color(.label))
                    
                    if let distance = place.distance {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("현재 위치로부터")
                                .appFontLight(size: 14)
                                .foregroundStyle(AppColor.gray)
                            
                            Text("\(distance.decimalString)m")
                                .appFontLight(size: 14)
                                .foregroundStyle(AppColor.gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 5)
                
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
            .tint(AppColor.gray)
            .padding(15)
        }
        .frame(width: width, height: height)
        .background(AppColor.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 5)
    }
}
