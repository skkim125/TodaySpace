//
//  WritePostView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/28/25.
//

import SwiftUI
import ComposableArchitecture

struct WritePostView: View {
    @Bindable var store: StoreOf<WritePostFeature>
    @Environment(\.dismiss) var dismiss
    @Namespace private var scrollSpace
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<3) { _ in
                                    Button {
                                        
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
                                                            .foregroundColor(AppColor.main)
                                                            .font(.system(size: 22, weight: .medium))
                                                    )
                                                
                                                Text("사진 추가")
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .foregroundColor(AppColor.subTitle)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        
                        VStack(spacing: 15) {
                            SophisticatedField(
                                icon: "bookmark.fill",
                                title: "제목",
                                placeholder: "제목을 입력하세요",
                                text: $store.title,
                                fieldType: .text
                            )
                            
                            SophisticatedField(
                                icon: "mappin.circle",
                                title: "공간",
                                placeholder: "오늘의 공간을 추가하세요",
                                text: $store.placeName,
                                fieldType: .button
                            )

                            SophisticatedField(
                                icon: "tag",
                                title: "카테고리",
                                placeholder: "카테고리를 선택하세요",
                                text: $store.category,
                                fieldType: .category
                            )

                            SophisticatedField(
                                icon: "calendar",
                                title: "방문일",
                                placeholder: "날짜를 선택하세요",
                                text: $store.date,
                                fieldType: .datePicker
                            )
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "text.alignleft")
                                        .foregroundColor(AppColor.subTitle)
                                    Text("공간에 대해...")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(AppColor.subTitle)
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
                        
                        Button {
                            
                        } label: {
                            Text("업로드")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColor.appBackground)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    store.buttonEnabled ? Color.white : Color.gray
                                )
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        .id(scrollSpace)
                    }
                }
            }
            .background(AppColor.appBackground)
            .navigationTitle("오늘의 공간 남기기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(AppColor.main)
                    }
                }
            }
        }
    }
}

enum FieldType {
    case text, button, category, datePicker
}

struct SophisticatedField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    @State private var selectedDate = Date()
    @State private var selectedCategory: String? = nil
    @State private var isButtonPressed = false
    @State private var showDatePicker = false
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    var fieldType: FieldType  // 필드 타입 추가
    var categories = ["Category 1", "Category 2", "Category 3"]  // 예시 카테고리
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .foregroundColor(AppColor.subTitle)
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColor.subTitle)
            }
            
            // 필드 타입에 따라 다른 UI 제공
            switch fieldType {
            case .button:
                Button(action: {
                    isButtonPressed.toggle()
                }) {
                    HStack {
                        Text(text.isEmpty ? placeholder : text)
                            .foregroundColor(text.isEmpty ? AppColor.subTitle : AppColor.main)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(AppColor.subTitle)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColor.appSecondary)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.grayStroke, lineWidth: 1)
                    )
                    .font(.system(size: 15))
                }
                
            case .category:
                
                HStack {
                    Text(selectedCategory ?? placeholder)
                        .foregroundColor(AppColor.subTitle)
                    Spacer()
                    Menu {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                text = category
                            }) {
                                Text(category)
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(AppColor.subTitle)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColor.appSecondary)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColor.grayStroke, lineWidth: 1)
                )
                .font(.system(size: 15))
                
            case .datePicker:
                Button(action: {
                    showDatePicker = true
                }) {
                    HStack {
                        Text(text.isEmpty ? placeholder : text)
                            .foregroundColor(AppColor.subTitle)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(AppColor.subTitle)
                    }
                    .contentShape(Rectangle())
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColor.appSecondary)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.grayStroke, lineWidth: 1)
                    )
                }
                .font(.system(size: 15))
                .sheet(isPresented: $showDatePicker) {
                    NavigationStack {
                        VStack {
                            DatePicker(
                                "",
                                selection: $selectedDate,
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
                                    showDatePicker = false
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("확인") {
                                    text = dateFormatter.string(from: selectedDate)
                                    showDatePicker = false
                                }
                            }
                        }
                    }
                    .presentationDetents([.medium])
                }
                
            case .text:
                TextField(placeholder, text: $text)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColor.appSecondary)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.grayStroke, lineWidth: 1)
                    )
                    .font(.system(size: 15))
            }
        }
        .padding(.horizontal, 20)
    }
}
