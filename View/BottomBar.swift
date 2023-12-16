//
//  BottomBar.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct BottomBar: View {
    @State var mydata = MyData()
    // タブの選択項目を保持する
    @State var selection = 1
    
    
    var body: some View {
        TabView(selection: $selection) {
            
            HomeScreen(user: $mydata)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1)

            IceListScreen()
                .tabItem {
                    Label("Ice", systemImage: "staroflife")
                }
                .tag(2)

            FriendListScreen(mydata: $mydata)
                .tabItem {
                    Label("Friends", systemImage: "person.3.sequence.fill")
                }
                .tag(3)

            AddFriendScreen(mydata: $mydata)
                .tabItem {
                    Label("Excahnge", systemImage: "arrow.left.arrow.right")
                }
                .tag(4)
        }
    }
}

