//
//  PostDetailView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/13/25.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct PostDetailView: View {
    @Bindable var store: StoreOf<PostDetailFeature>
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            if store.isLoading {
                CustomProgressView()
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center, spacing: 5) {
                            ImageView(imageURL: store.postCreatorProfile, frame: .setFrame(35, 35), errorImage: Image("exclamationmark.triangle.fill"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(store.postCreatorName)")
                                    .foregroundStyle(AppColor.white)
                                    .appFontBold(size: 14)
                                
                                Text("\(DateFormatter.convertDateString(store.createdAt, type: .formatted))")
                                    .appFontBold(size: 12)
                                    .foregroundStyle(AppColor.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text(store.title)
                            .appFontBold(size: 20)
                        
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: store.categoryImage)
                                        .appFontBold(size: 18)
                                        .foregroundColor(AppColor.appGold)
                                    
                                    Text(store.placeName)
                                        .appFontBold(size: 18)
                                }
                                
                                Text(store.placeAddress)
                                    .appFontBold(size: 14)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .appFontBold(size: 14)
                                .foregroundColor(AppColor.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColor.appSecondary)
                        }
                        .onTapGesture {
                            store.showPlaceLocationSheet.toggle()
                        }
                        
                        imageListView()
                        
                        Text(store.content)
                        
                        Divider()
                        
                        VStack {
                            HStack(alignment: .bottom, spacing: 20) {
                                HStack(alignment: .center, spacing: 5) {
                                    Button {
                                        store.send(.toggleLiked)
                                    } label: {
                                        Image(systemName: store.isLiked ? "star.fill" : "star")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(AppColor.appGold)
                                            .frame(width: 25, height: 25)
                                            .bold()
                                    }
                                    
                                    Text("\(store.likeCount.decimalString)")
                                        .appFontBold(size: 16)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "text.bubble.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .bold()
                                    
                                    Text("\(store.comments.count)개")
                                        .appFontBold(size: 16)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        if store.comments.isEmpty {
                            Text("첫 댓글을 작성해보세요!")
                                .appFontBold(size: 24)
                                .padding(.vertical, 20)
                        } else {
                            ForEach(store.comments, id: \.comment_id) { comment in
                                CommentView(postCreatorID: store.postCreatorID, comment: comment)
                                    .id(comment.comment_id)
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .padding(.vertical, 5)
                .scrollIndicators(.never)
                .onChange(of: store.comments) { oldValue, newValue in
                    if !oldValue.isEmpty {
                        if let lastComment = newValue.last {
                            proxy.scrollTo(lastComment.comment_id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $store.showPlaceLocationSheet) {
            VStack {
                Map(position: .constant(MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: store.lat, longitude: store.lon), distance: 300))), interactionModes: [.pan, .zoom]) {
                    
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: store.lat, longitude: store.lon)) {
                        CustomMarkerView(placeName: "\(store.placeName)")
                    }
                }
            }
            .padding(.top, 5)
            .padding(25)
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])
        }
        .fullScreenCover(isPresented: $store.showPlaceWebView) {
            WebView(urlString: store.placeLink)
                .ignoresSafeArea(edges: .bottom)
                .customNavigationBar {
                    EmptyView()
                } leftView: {
                    VStack {
                        Button {
                            store.showPlaceWebView = false
                        } label: {
                            Text("닫기")
                                .appFontBold(size: 18)
                        }
                        .tint(AppColor.white)
                    }
                } rightView: {
                    EmptyView()
                }
            
        }
        .onTapGesture {
            isFocused = false
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(AppColor.appBackground)
        .customNavigationBar {
            VStack(spacing: 5) {
                Text("\(store.visitedDate)")
                    .foregroundStyle(AppColor.white)
                    .appFontBold(size: 14)
                
                Text("\(store.postCreatorName)님의 공간")
                    .foregroundStyle(AppColor.white)
                    .appFontBold(size: 12)
            }
        } leftView: {
            Button {
                store.send(.dismiss)
            } label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .tint(AppColor.white)
        } rightView: {
            Menu {
                if store.postCreatorID == UserDefaultsManager.userID {
                    Button(role: .destructive, action: {
                        
                    }) {
                        HStack {
                            Text("게시물 삭제")
                            
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                
                Button {
                    store.send(.showPlaceWebView)
                } label: {
                    HStack {
                        Text("공간 알아보기")
                        
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .tint(AppColor.white)
            }
        }
        .safeAreaInset(edge: .bottom) {
            commentInputView()
        }
        .onAppear {
            store.send(.viewAppear)
        }
    }
    
    @ViewBuilder
    private func commentInputView() -> some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack {
                TextField("댓글을 입력하세요", text: $store.commentText)
                    .padding(10)
                    .background(AppColor.appSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .focused($isFocused)
                
                if !store.commentText.isEmpty {
                    Button {
                        isFocused = false
                        store.send(.commentButtonTap)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(AppColor.white, store.commentText.isEmpty ? AppColor.gray : AppColor.appGold)
                            .clipShape(Circle())
                            .frame(width: 28, height: 28)
                    }
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            .animation(.easeInOut, value: store.commentText)
        }
        .background(AppColor.appBackground)
    }
    
    @ViewBuilder
    private func imageListView() -> some View {
        if store.images.count == 1 {
            ImageView(imageURL: store.images[0], frame: .auto, errorImage: Image("exclamationmark.triangle.fill"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<store.images.count, id: \.self) { index in
                        ImageView(imageURL: store.images[index], frame: .setFrame(UIScreen.main.bounds.width - 100, 300), errorImage: Image("exclamationmark.triangle.fill"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8).stroke(AppColor.grayStroke, lineWidth: 1)
                                    VStack(alignment: .center) {
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Circle()
                                                .fill(AppColor.appGold)
                                                .overlay {
                                                    Text("\(index + 1)")
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(AppColor.white)
                                                        .multilineTextAlignment(.center)
                                                }
                                                .frame(width: 25, height: 25)
                                        }
                                        .padding(10)
                                    }
                                }
                            }
                            .padding(.horizontal, index != 0 && index != 4 ? 10 : 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
