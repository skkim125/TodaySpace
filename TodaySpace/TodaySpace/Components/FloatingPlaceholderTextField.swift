//
//  FloatingPlaceholderTextField.swift
//  TodaySpace
//
//  Created by 김상규 on 2/25/25.
//

import SwiftUI

struct FloatingPlaceholderTextField<Field: Hashable>: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var focusField: FocusState<Field?>.Binding
    var field: Field
    
    private var shouldFloat: Bool {
        focusField.wrappedValue == field || !text.isEmpty
    }
    
    var body: some View {
        ZStack {
            Text(placeholder)
                .foregroundColor(.gray)
                .appFontBold(size: shouldFloat ? 12 : 16)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: Alignment(horizontal: .leading, vertical: shouldFloat ? .top : .center))
                .padding(.top, shouldFloat ? 10 : 0)
                .padding(.horizontal, 10)
                .animation(.easeInOut(duration: 0.3), value: shouldFloat)
            
            VStack {
                if isSecure {
                    SecureField("", text: $text)
                        .appFontBold(size: 16)
                } else {
                    TextField("", text: $text)
                        .appFontBold(size: 16)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .keyboardType(.twitter)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .offset(y: 8)
        }
        .frame(height: 50)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        }
        .focused(focusField, equals: field)
    }
}
