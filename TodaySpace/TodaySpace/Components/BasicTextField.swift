//
//  BasicTextField.swift
//  TodaySpace
//
//  Created by 김상규 on 2/25/25.
//

import SwiftUI

struct BasicTextField: View {
    @Binding var text: String
    let placeHolder: String
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeHolder).foregroundStyle(AppColor.subTitle))
            .foregroundStyle(AppColor.white)
            .fieldBackground()
    }
}
