//
//  MapMarker.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI
import MapKit

struct MapMarker: View {
    var body: some View {
        VStack {
            ZStack {
                Triangle()
                    .frame(width: 20, height: 25)
                    .padding(.top, 28)
                    .shadow(radius: 1, x: 0, y: 5)
                
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 35, height: 35)
                    .overlay {
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white)
                        Text("+10")
                            .font(.system(size: 12))
                    }
            }
        }
        .foregroundStyle(.black)
    }
}
