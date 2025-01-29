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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 5) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<1) { value in
                                Button {
                                    
                                } label: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray, lineWidth: 0.3)
                                        .fill(Color.clear)
                                        .frame(width: 80, height: 100)
                                        .background {
                                            VStack {
                                                Circle()
                                                    .stroke(.gray, lineWidth: 2)
                                                    .frame(width: 30, height: 30)
                                                    .overlay {
                                                        Image(systemName: "plus")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .fontWeight(.bold)
                                                            .frame(width: 12, height: 12)
                                                            .foregroundStyle(.gray)
                                                    }
                                                    .padding(.top)
                                                
                                                Spacer()
                                                
                                                Text("사진 추가")
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(.gray)
                                                    .padding(.bottom)
                                            }
                                        }
                                }
                                .padding(.horizontal, 5)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                    }
                    .background(Color(uiColor: .systemBackground))
                    
                    Color(uiColor: .tertiarySystemGroupedBackground)
                        .frame(height: 5)
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color(uiColor: .systemBackground))
                            .overlay {
                                HStack(alignment: .center) {
                                    TextField("제목", text: $store.title)
                                        .padding(.horizontal, 10)
                                    
                                    Spacer()
                                }
                            }
                            .frame(height: 50)
                        
                        Divider()
                            .frame(height: 1)
                        
                        Rectangle()
                            .fill(Color(uiColor: .systemBackground))
                            .overlay {
                                HStack(alignment: .center) {
                                    TextField("장소 추가", text: $store.placeName)
                                        .padding(.horizontal, 10)
                                    
                                    Spacer()
                                }
                            }
                            .frame(height: 50)
                        
                        Divider()
                            .frame(height: 1)
                        
                        Rectangle()
                            .fill(Color(uiColor: .systemBackground))
                            .overlay {
                                HStack(alignment: .center) {
                                    TextField("카테고리", text: $store.category)
                                        .padding(.horizontal, 10)
                                    
                                    Spacer()
                                }
                            }
                            .frame(height: 50)
                        
                        Divider()
                            .frame(height: 1)
                        
                        Rectangle()
                            .fill(Color(uiColor: .systemBackground))
                            .overlay {
                                HStack(alignment: .center) {
                                    TextField("방문한 날짜", text: $store.date)
                                        .padding(.horizontal, 10)
                                    
                                    Spacer()
                                }
                            }
                            .frame(height: 50)
                        
                        Divider()
                            .frame(height: 1)
                        
                        Rectangle()
                            .fill(Color(uiColor: .systemBackground))
                            .overlay {
                                HStack(alignment: .center) {
                                    TextField("내용 작성하기", text: $store.contents)
                                        .padding(.horizontal, 10)
                                    
                                    Spacer()
                                }
                            }
                        
                        RoundedButton(text: "작성 완료", foregroundColor: .white, backgroundColor: .gray)
                            .padding(.horizontal, 20)
                            .padding(.bottom)
                    }
                }
                .scrollDisabled(true)
                .navigationTitle("오늘의 장소 남기기")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
    }
}
