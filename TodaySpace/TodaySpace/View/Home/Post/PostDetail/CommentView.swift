//
//  CommentView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/20/25.
//

import SwiftUI

struct CommentView: View {
    let postCreatorID: String
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let imageURL = comment.creator?.profileImage, !imageURL.isEmpty {
                ImageView(imageURL: imageURL, frame: .setFrame(40, 40))
                    .overlay(
                        Circle().stroke(AppColor.grayStroke, lineWidth: 1)
                    )
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(AppColor.subTitle)
                    .strokeBorder(AppColor.grayStroke, lineWidth: 1)
                    .overlay(alignment: .center) {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(AppColor.black)
                    }
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .center, spacing: 5) {
                    Text("\(comment.creator?.nick ?? "")")
                        .appFontBold(size: 15)
                        .bold((postCreatorID == comment.creator?.user_id ?? ""))
                        .foregroundStyle((postCreatorID == comment.creator?.user_id ?? "") ? AppColor.appGold : AppColor.white)
                    
                    Text("\(DateFormatter.convertDateString(comment.createdAt ?? "", type: .relative))")
                        .appFontLight(size: 13)
                        .foregroundStyle(AppColor.gray)
                }
                
                Text("\(comment.content ?? "")")
                    .appFontLight(size: 14)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(AppColor.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}

//#Preview {
//    CommentView(postCreaterID: <#String#>, comment: Comment(comment_id: "123122312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_id: "", nick: "바라쿠타", profileImage: "")))
//}
