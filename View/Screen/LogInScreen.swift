//
//  LogInScreen.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI
import FirebaseAuth

struct LogInScreen: View {
    
    @ObservedObject private var myVM = ViewModel()
    @State var mydata = MyData()
    
    @State public var mail:String = ""
    @State public var password:String = ""
    @State public var errorMessage:String = ""
    
    var body: some View {
        
        NavigationView{
            ZStack(){
                
                //背景
                Image("screen_background")
                    .opacity(0.5)
                
                //画面タイトル
                ScreenTitle(title: "LogIn")
                
                VStack(spacing: 20){
                    
                    // メールアドレス
                    TextField("メールアドレスを入力してください",text: $mail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // パスワード
                    SecureField("パスワードを入力してください",text:$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    //メールログインボタン
                    Button(
                        action:{
                            if(self.mail == ""){
                                self.errorMessage = "メールアドレスが入力されていません"
                            } else if(self.password == ""){
                                self.errorMessage = "パスワードが入力されていません"
                            } else {
                                
                                Auth.auth().signIn(withEmail: self.mail, password: self.password) { authResult, error in
                                    if authResult?.user != nil {
                                        
                                    } else {
                                        // ログイン失敗処理
                                        if let error = error {
                                            let err = error as NSError
                                            if let authErrorCode = AuthErrorCode.Code(rawValue: err.code) {
                                                switch authErrorCode {
                                                case .invalidEmail:
                                                    self.errorMessage = "メールアドレスの形式が正しくありません"
                                                case .userNotFound, .wrongPassword:
                                                    self.errorMessage = "メールアドレス、またはパスワードが間違っています"
                                                case .userDisabled:
                                                    self.errorMessage = "このユーザーアカウントは無効化されています"
                                                default:
                                                    self.errorMessage = err.domain
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        },label:{
                            Text("ログインする")
                        })
                    
                    //googleログインボタン
                    Image("google_icon")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            myVM.googleSignIn()
                        }
                    
                    Text("Sign in with google")
                   
                    
                }
                .frame(width: width, height: height)
                
            }.sheet(isPresented: $myVM.userSignedIn) {
                // ログイン後のページ
                BottomBar()
            }
            
        }
    }
}


