//
//  ExchangeScreen.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct AddFriendScreen: View {
    @Binding var mydata : UserInfo
    @ObservedObject private var viewModel = ViewModel()
    @State var showSheet: Bool = false

    var body: some View {
        ZStack{
            QRScan()
            //画面タイトル
            ScreenTitle(title: "Exchange")
            
            Button(action: {
                // ボタンタップで状態変数の値を切り替える
                showSheet.toggle()
            }, label: {
                Text("MyQR")
                
            }).font(.system(size: width/15))
                .padding(.top, height/1.5)
            
        }
        .sheet(isPresented: $showSheet){
            QRScreen(mydata: mydata)
        }
        
    }
}
