//
//  CustomTabBar.swift
//  TodaySpace
//
//  Created by 김상규 on 2/26/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabInfo
    
    var body: some View {
        HStack {
            ForEach([TabInfo.home, TabInfo.map, TabInfo.dm, TabInfo.myPage], id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        
                        Text(tab.rawValue)
                            .appFontBold(size: 10)
                    }
                    .foregroundColor(selectedTab == tab ? AppColor.appGold : AppColor.gray)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(AppColor.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColor.appGold, lineWidth: 1)
        }
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
