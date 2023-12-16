//
//  CustomScreen.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct CustomProfileScreen: View {
    @ObservedObject private var viewModel = ViewModel()
    @Binding var myCard : UserInfo
    
    var body: some View {
        ZStack(){
            
            //背景
            Image("screen_background")
                .opacity(0.5)
            
            //画面タイトル
            ScreenTitle(title: "Custom")
            
            VStack{
                
                CustomCard(myName: $myCard.name, myAge: $myCard.age, myJob: $myCard.job, myWeight: $myCard.weight, myChange: $myCard.change, myIcon: $myCard.icon
                )
                
                ScrollView(.vertical){
                    VStack(){
                        CustomText(user : $myCard.name, title: "名前", field: "name", height: 25)
                        CustomNum(user : $myCard.age, title: "年齢", field: "age", height: 25)
                        CustomText(user : $myCard.job, title: "職業", field: "job", height: 25)
                        CustomNum(user : $myCard.weight, title: "体重", field: "weight", height: 25)
                        CustomIcon(avater: $myCard.icon)
                        UpDataBUtton(myCard: $myCard)
                    }
                }.padding(.top, 30).padding(.bottom, 200)
                
            }.frame(width: card_width, height: .infinity,alignment: .top)
                .padding(.top, 230)
        }
    }
}
