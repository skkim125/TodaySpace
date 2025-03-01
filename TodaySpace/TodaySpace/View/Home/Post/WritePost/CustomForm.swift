//
//  CustomForm.swift
//  TodaySpace
//
//  Created by 김상규 on 2/25/25.
//

import SwiftUI
import ComposableArchitecture

enum FieldType {
    case text, place, category, datePicker
}

struct CustomForm: View {
    let icon: String
    let title: String
    let placeholder: String
    let fieldType: FieldType
    let categories: [String]
    @Bindable var store: StoreOf<WritePostFeature>
    @Binding var text: String
    
    init(
        store: Bindable<StoreOf<WritePostFeature>>,
        icon: String,
        title: String,
        placeholder: String,
        text: Binding<String>,
        fieldType: FieldType,
        categories: [String] = Category.allCases.map { $0.rawValue }
    ) {
        self._store = store
        self.icon = icon
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.fieldType = fieldType
        self.categories = categories
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleRow
            
            switch fieldType {
            case .place:
                placeField(store: store)
            case .category:
                categoryField
            case .datePicker:
                datePickerField
            case .text:
                BasicTextField(text: $text, placeHolder: placeholder)
            }
        }
        .background(AppColor.appBackground)
        .padding(.horizontal, 20)
    }
    
    private var titleRow: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundStyle(AppColor.subTitle)
            Text(title)
                .appFontLight(size: 15)
                .foregroundStyle(AppColor.subTitle)
        }
    }
    
    private func placeField(store: StoreOf<WritePostFeature>) -> some View {
        Button {
            store.send(.addPlaceButtonClicked)
        } label: {
            HStack {
                Text(text.isEmpty ? placeholder : text)
                    .foregroundStyle(text.isEmpty ? AppColor.subTitle : AppColor.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColor.subTitle)
            }
            .fieldBackground()
        }
    }
    
    private var categoryField: some View {
        HStack {
            Text(store.category.isEmpty ? placeholder : store.category)
                .foregroundStyle(text.isEmpty ? AppColor.subTitle : AppColor.white)
            
            Spacer()
            
            Menu {
                ForEach(categories, id: \.self) { category in
                    Button {
                        store.category = category
                        text = category
                    } label: {
                        Text(category)
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(AppColor.subTitle)
            }
        }
        .fieldBackground()
    }
    
    private var datePickerField: some View {
        Button {
            store.showDatePicker = true
        } label: {
            HStack {
                Text(text.isEmpty ? placeholder : text)
                    .foregroundStyle(text.isEmpty ? AppColor.subTitle : AppColor.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColor.subTitle)
            }
            .contentShape(Rectangle())
            .fieldBackground()
        }
        .sheet(isPresented: $store.showDatePicker) {
            datePickerSheet
        }
    }
    
    private var datePickerSheet: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "",
                    selection: $store.date,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
            }
            .navigationTitle("날짜 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        store.showDatePicker = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("확인") {
                        text = DateFormatter.yearDateFormatter.string(from: store.date)
                        store.showDatePicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
