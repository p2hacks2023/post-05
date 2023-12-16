//
//  FriendList.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct FriendList: View {
    var users: [UserInfo]

    var body: some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(Array(users.enumerated()), id: \.offset){offset, user in
                    FriendIcon(index: offset, list: users)
                                   
                }.frame(width: 100, height: 140)
                    .background(Color.clear)
                    .opacity(0.9)
                    .padding(.vertical,5)

            }
        }.background(Color.clear)
    }
}

struct FriendIcon: View {
    var index: Int
    var list: [UserInfo]
    
    var body: some View {
            VStack(){
                Image(list[index].icon)
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                Text(list[index].name)
            }.frame(width: 100, height: 130)
                .background()
                .cornerRadius(20)
                .shadow(radius: 10)
                .opacity(0.9)
                .onTapGesture {}
        }
}


