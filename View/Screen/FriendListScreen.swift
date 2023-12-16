//
//  LibraryScreen.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct FriendListScreen: View {
    @ObservedObject private var viewModel = ViewModel()
    @Binding var mydata : UserInfo
    var body: some View {
        //画面サイズ取得
        let bound = UIScreen.main.bounds
        let width = CGFloat(bound.width)
        let height = CGFloat(bound.height)
        //カードの縦横サイズ定義
        let card_width = width * 0.85
        let card_height = card_width / 1.618
        
        ZStack(){
            
            //背景
            Image("screen_background")
                .opacity(0.5)
            
            //画面タイトル
            ScreenTitle(title: "Friends")
            
            Card(card_data: $mydata)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 230).padding(.horizontal, 5)
            
            /*
            List(viewModel.users) { user in
                VStack(alignment: .leading) {
                    Text(user.name).font(.title)
                    Text("誕生日 :" + user.birthday)
                    Text("一言 :" + user.message)
                }
            }.frame(maxWidth: card_width, maxHeight: height, alignment: .top)
                .padding(.top, 270).padding(.horizontal, 5)
                .onAppear {
                    self.viewModel.fetchFireStore()
                    }
             */
            
            FriendList(users: viewModel.users)
                .frame(maxWidth: card_width, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom,300)
                .onAppear {
                    /*
                    Task {
                        try await self.viewModel.fetchFireStore()
                    }
                     */
                }
        }

    }
}
