//
//  HomeScreen.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct HomeScreen: View {
    @Binding var user : UserInfo
    @ObservedObject private var myVM = ViewModel()
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationView{
            
            ZStack(){
                
                //背景
                Image("screen_background")
                    .opacity(0.5)
                
                //画面タイトル
                ScreenTitle(title: "Home")
                
                VStack{
                    //LogOutButton()
                    Button(action: {
                        do {
                            try myVM.signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    }, label: {
                        Text("LogOut")
                    })
                    
                    Button(action: {
                        // ボタンタップで状態変数の値を切り替える
                        showSheet.toggle()
                    }, label: {
                        Text("Custom")
                    })
                    
                    Button(action: {
                        myVM.uploadImage(file: "screen_background.png")
                    }, label: {
                        Text("Upload")
                    })
                    
                    Button(action: {
                        myVM.downloadImage(file: "image-5.png") { downloadedImage in
                            if let image = downloadedImage {
                                // ダウンロードが成功した場合の処理
                                // このブロック内で取得した画像を使用できます
                                DispatchQueue.main.async {
                                }
                            } else {
                                // ダウンロードが失敗した場合の処理
                                print("画像のダウンロードに失敗しました")
                            }
                        }
                    }, label: {
                        Text("Download")
                    })
                    
                }
                
                Card(card_data: $user)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 230)
                
            }.sheet(isPresented: $showSheet){
                CustomProfileScreen(myCard: $user)
            }
        }
    }
}
