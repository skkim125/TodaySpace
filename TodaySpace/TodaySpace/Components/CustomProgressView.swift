//
//  CustomProgressView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/28/25.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(AppColor.grayStroke)
            .frame(width: 50, height: 50)
            .overlay {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
