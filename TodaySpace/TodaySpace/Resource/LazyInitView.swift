//
//  LazyInitView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI

struct LazyInitView<Content: View>: View {
    let view: () -> Content
    
    init(_ view: @escaping () -> Content) {
        self.view = view
    }
    
    var body: Content {
        view()
    }
}
