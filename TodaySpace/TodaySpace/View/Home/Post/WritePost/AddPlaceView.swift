//
//  AddPlaceView.swift
//  TodaySpace
//
//  Created by 김상규 on 1/31/25.
//

import SwiftUI
import ComposableArchitecture

struct AddPlaceView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<AddPlaceFeature>

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 15) {
                TextField("ex) 뮤직컴플렉스 서울", text: $store.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button {
                    store.send(.searchButtonTapped)
                } label: {
                    Text("검색")
                        .asRoundButton(foregroundColor: AppColor.white, backgroundColor: AppColor.appGold)
                }
                .padding(.horizontal)
            }
            .padding(.top)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(store.state.results, id: \.id) { place in
                        Button {
                            store.send(.selectPlace(place))
                            dismiss()
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(place.customCategory)
                                        .appFontLight(size: 14)
                                        .foregroundStyle(AppColor.gray)
                                    
                                    Text(place.placeName)
                                        .lineLimit(1)
                                        .appFontBold(size: 20)
                                        .bold()
                                }
                                
                                Text(place.roadAddress.isEmpty ? place.address : place.roadAddress)
                                    .appFontLight(size: 16)
                                    .foregroundColor(AppColor.lightGray)
                            }
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(AppColor.appSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity)
            .padding(.top, 10)
        }
        .frame(maxHeight: .infinity)
        .background(AppColor.appBackground)
        .navigationTitle("공간 검색")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .tint(AppColor.white)
            }
        }
    }
}
