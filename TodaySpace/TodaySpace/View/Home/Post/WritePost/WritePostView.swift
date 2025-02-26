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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        imageListView()
                        
                        VStack(spacing: 15) {
                            CustomForm(
                                store: $store,
                                icon: "bookmark.fill",
                                title: "제목",
                                placeholder: "제목을 입력하세요",
                                text: $store.title,
                                fieldType: .text
                            )
                            .focused($isFocused)
                            
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
                                        .appFontBold(size: 13)
                                        .foregroundStyle(AppColor.subTitle)
                                }
                                
                                TextEditor(text: $store.contents)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 80, maxHeight: 100)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(AppColor.appSecondary)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(AppColor.grayStroke, lineWidth: 1)
                                    )
                                    .appFontLight(size: 15)
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(scrollSpace, anchor: .bottom)
                                        }
                                    }
                            }
                            .padding(.horizontal, 20)
                            .focused($isFocused)
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
            .onTapGesture {
                isFocused = false
            }
        } destination: { store in
            switch store.case {
            case .addPlace(let store):
                return AddPlaceView(store: store)
            }
        }
        .tint(AppColor.white)
    }
    
    @ViewBuilder
    func uploadButton() -> some View {
        
        if store.buttonEnabled {
            Button {
                store.send(.uploadButtonClicked)
            } label: {
                Text("업로드")
                    .asRoundButton(foregroundColor: AppColor.white, backgroundColor: AppColor.appGold)
                    .appFontBold(size: 18)
            }
        } else {
            Text("업로드")
                .asRoundButton(foregroundColor: AppColor.white, backgroundColor: AppColor.gray)
                .appFontBold(size: 18)
        }
    }
    
    @ViewBuilder
    func imageListView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(store.selectedImages.indices, id: \.self) { index in
                    Image(uiImage: store.selectedImages[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
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
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColor.appSecondary)
                                .frame(width: 120, height: 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColor.grayStroke, lineWidth: 1)
                                )
                            
                            VStack(spacing: 15) {
                                Circle()
                                    .fill(AppColor.grayStroke)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "photo.badge.plus")
                                            .foregroundStyle(AppColor.white)
                                            .appFontBold(size: 22)
                                    )
                                
                                Text("사진 추가")
                                    .appFontBold(size: 13)
                                    .foregroundStyle(AppColor.subTitle)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}
