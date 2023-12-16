//
//  SpaceScreen.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI


struct IceGenerateScreen: View {
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
            
            Image("screen_background")
                .opacity(0.5)
            Text("SPACE")
                .frame(maxWidth: card_width, maxHeight: height, alignment: .topLeading)
                .font(.system(size: 40))
                .fontWeight(.heavy)
                .padding(.top, 150).padding(.leading, 10)
                .opacity(0.7)
                .foregroundColor(Color.white)
            
            Card(card_data: $mydata)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 230)
        }
    }
}

