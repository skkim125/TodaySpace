//
//  WritePostView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/28/25.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct WritePostView: View {
    @Bindable var store: StoreOf<WritePostFeature>
    @Namespace private var scrollSpace
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(store.selectedImages.indices, id: \.self) { index in
                                    Image(uiImage: store.selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(AppColor.grayStroke, lineWidth: 1)
                                        )
                                        .overlay(
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    
                                                    Button {
                                                        store.send(.removePhoto(index), animation: .default)
                                                    } label: {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundStyle(AppColor.white, .red)
                                                    }
                                                    .shadow(color: AppColor.white, radius: 1)
                                                }
                                                .padding(.all, 5)
                                                
                                                Spacer()
                                            }
                                        )
                                }
                                
                                if store.selectedImages.count < 5 {
                                    Button {
                                        store.isPickerPresented = true
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(AppColor.appSecondary)
                                                .frame(width: 120, height: 150)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(AppColor.grayStroke, lineWidth: 1)
                                                )
                                            
                                            VStack(spacing: 15) {
                                                Circle()
                                                    .fill(AppColor.grayStroke)
                                                    .frame(width: 50, height: 50)
                                                    .overlay(
                                                        Image(systemName: "photo.badge.plus")
                                                            .foregroundStyle(AppColor.white)
                                                            .font(.system(size: 22, weight: .medium))
                                                    )
                                                
                                                Text("사진 추가")
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .foregroundStyle(AppColor.subTitle)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        
                        VStack(spacing: 15) {
                            CustomForm(
                                store: $store,
                                icon: "bookmark.fill",
                                title: "제목",
                                placeholder: "제목을 입력하세요",
                                text: $store.title,
                                fieldType: .text
                            )
                            
                            CustomForm(
                                store: $store,
                                icon: "mappin.circle",
                                title: "공간",
                                placeholder: "오늘의 공간을 추가하세요",
                                text: $store.placeName,
                                fieldType: .place
                            )
                            
                            CustomForm(
                                store: $store,
                                icon: "tag",
                                title: "카테고리",
                                placeholder: "카테고리를 선택하세요",
                                text: $store.category,
                                fieldType: .category
                            )
                            
                            CustomForm(
                                store: $store,
                                icon: "calendar",
                                title: "방문일",
                                placeholder: "날짜를 선택하세요",
                                text: $store.dateString,
                                fieldType: .datePicker
                            )
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "text.alignleft")
                                        .foregroundStyle(AppColor.subTitle)
                                    Text("공간에 대해...")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(AppColor.subTitle)
                                }
                                
                                TextEditor(text: $store.contents)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 80, maxHeight: 100)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(AppColor.appSecondary)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(AppColor.grayStroke, lineWidth: 1)
                                    )
                                    .font(.system(size: 15))
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(scrollSpace, anchor: .bottom)
                                        }
                                    }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                        
                        uploadButton()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                            .id(scrollSpace)
                    }
                }
            }
            .photosPicker(isPresented: $store.isPickerPresented, selection: $store.selectedItems, maxSelectionCount: 5, selectionBehavior: .ordered, matching: .images)
            .onChange(of: store.selectedItems) { oldValue, newValue in
                store.send(.addPhoto(newValue))
            }
            .background(AppColor.appBackground)
            .navigationTitle("오늘의 공간 남기기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.send(.dismiss)
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(AppColor.white)
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case .addPlace(let store):
                return AddPlaceView(store: store)
            }
        }
    }
    
    @ViewBuilder
    func uploadButton() -> some View {
        
        if store.buttonEnabled {
            Button {
                store.send(.uploadButtonClicked)
            } label: {
                Text("업로드")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColor.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        AppColor.appGold
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        } else {
            Text("업로드")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppColor.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    AppColor.gray
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}

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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
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
                textField
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
                .font(.system(size: 13, weight: .medium))
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
                    Button(action: {
                        store.category = category
                        text = category
                    }) {
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
                        text = dateFormatter.string(from: store.date)
                        store.showDatePicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var textField: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(AppColor.subTitle))
            .foregroundStyle(AppColor.white)
            .fieldBackground()
    }
}

extension View {
    func fieldBackground() -> some View {
        self
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppColor.appSecondary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(AppColor.grayStroke, lineWidth: 1)
            )
            .font(.system(size: 15))
    }
}
