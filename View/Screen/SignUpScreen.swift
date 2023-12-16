//
//  SignUpScreen.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI
import FirebaseAuth

struct SignUpScreen: View {
    @State public var mail:String = ""
    @State public var password:String = ""
    @State public var errorMessage:String = ""
    
    var body: some View {
        VStack(spacing: 10){
            // メールアドレス
            TextField("メールアドレスを入力してください",text: $mail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // パスワード
            SecureField("パスワードを入力してください",text:$password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // 認証
            Button(
                action:{
                    if(self.mail != ""){
                        self.errorMessage = "メールアドレスが入力されていません"
                    } else if(self.password != ""){
                        self.errorMessage = "パスワードが入力されていません"
                    } else {
                        // 認証する処理
                        Auth.auth().createUser(withEmail: self.mail, password: self.password) { authResult, error in
                            print(authResult)
                        }
                    }
                }, label:{
                    Text("新規会員登録する")
                })
        }.padding(30)
    }
}


