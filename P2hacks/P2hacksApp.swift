//
//  P2hacksApp.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

import SwiftUI
import FirebaseCore
import Firebase //ここを記入
import Firebase
import GoogleSignIn

//画面サイズ取得
let bound = UIScreen.main.bounds
let width = CGFloat(bound.width)
let height = CGFloat(bound.height)

//カードの縦横サイズ定義
let card_width = width * 0.85
let card_height = card_width / 1.618

// struct @mainで呼ぶ場合は、AppDelegateを以下にかいて呼び出す。
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
          -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct P2hacksApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var mydata = MyData()
    
    @StateObject var myVM = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            // ログイン状態によって画面遷移するページを変更する
            if myVM.userSignedIn {
                BottomBar()
            } else {
                LogInScreen()
            }
        }
    }
}
