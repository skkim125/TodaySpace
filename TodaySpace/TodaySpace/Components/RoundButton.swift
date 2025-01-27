//
//  RoundButton.swift
//  TodaySpace
//
//  Created by 김상규 on 1/27/25.
//

import SwiftUI

struct RoundedButton: View {
    var text: String
    var foregroundColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(text)
            .asRoundButton(foregroundColor: foregroundColor, backgroundColor: backgroundColor)
    }
}
