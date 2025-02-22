//
//  CommentView.swift
//  TodaySpace
//
//  Created by 김상규 on 2/20/25.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let imageURL = comment.creator.profileImage, !imageURL.isEmpty {
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
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center, spacing: 5) {
                    Text("\(comment.creator.nick ?? "")")
                        .font(.system(size: 15))
                    
                    Text("\(DateFormatter.convertDateString(comment.createdAt ?? ""))")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColor.gray)
                }
                
                Text("\(comment.content ?? "")")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
    }
}

#Preview {
    CommentView(comment: Comment(comment_id: "123122312", content: "오 여기 좋더라구요", createdAt: "2025년 88월 88일", creator: User(user_Id: "", nick: "바라쿠타", profileImage: "")))
}
