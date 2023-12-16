//
//  SwiftUIView.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct Card: View {
    @Binding var card_data: UserInfo
    var body: some View {
        ZStack(){
            Image("card_background8")
            
            HStack(alignment: .top){
                VStack(){
                    Text(card_data.name)
                        .font(.system(size: 28))
                        .fontWeight(.black)
                    
                    HStack{
                        Image(systemName: "figure.dress.line.vertical.figure")
                            .resizable()
                            .frame(width: 11, height: 11)
                        
                        Text("card_data.age")
                            .font(.system(size: 10))
                        
                        Image(systemName: "bag.fill")
                            .resizable()
                            .frame(width:11, height: 11)
                        Text(card_data.job)
                            .font(.system(size: 10))
                        
                    }.frame(width: card_width/1.85, height: card_height/15,alignment: .leading)
                        .padding(.horizontal, 10)
                        .background()
                        .cornerRadius(30)
                        .opacity(0.8)
                    
                }.frame(maxWidth: card_width,alignment: .leading)
                
                VStack(){
                    Image(card_data.icon)
                        .resizable()
                        .frame(width: card_width/4, height: card_height/2.5)
                        .background(Color.white)
                        .cornerRadius(8)
                        .opacity(0.9)
                    
                    Text(String(card_data.weight))
                        .font(.system(size: 10))
                    
                    Text(String(card_data.change))
                        .font(.system(size: 10))
                    
                }
                
            }.padding(.vertical, 20).padding(.horizontal, 15)
                .frame(maxWidth: card_width, maxHeight: card_height)
        }
    }
}


struct CustomCard: View {
    @Binding var myName : String
    @Binding var myAge : Int
    @Binding var myJob : String
    @Binding var myWeight : Int
    @Binding var myChange : Int
    @Binding var myIcon : String
    
    var body: some View {
        ZStack(){
            Image("card_background8")
            
            HStack(alignment: .top){
                VStack(){
                    Text(myName)
                        .font(.system(size: 28))
                        .fontWeight(.black)
                    
                    HStack{
                        
                        Image(systemName: "figure.dress.line.vertical.figure")
                            .resizable()
                            .frame(width: 11, height: 11)
                        
                        Text(String(myAge))
                            .font(.system(size: 10))
                        
                        Image(systemName: "bag.fill")
                            .resizable()
                            .frame(width:11, height: 11)
                        
                        Text(myJob)
                            .font(.system(size: 10))
                        
                    }.frame(width: card_width/1.85, height: card_height/15,alignment: .leading)
                        .padding(.horizontal, 10)
                        .background()
                        .cornerRadius(30)
                        .opacity(0.8)
                    
                }.frame(maxWidth: card_width,alignment: .leading)
                
                VStack(){
                    Image(myIcon)
                        .resizable()
                        .frame(width: card_width/4, height: card_height/2.5)
                        .background(Color.white)
                        .cornerRadius(8)
                        .opacity(0.9)
                    
                    Text(String(myWeight))
                        .font(.system(size: 10))
                    
                    Text(String(myChange))
                        .font(.system(size: 10))
                    
                }
                
            }.padding(.vertical, 20).padding(.horizontal, 15)
                .frame(maxWidth: card_width, maxHeight: card_height)
        }
    }
}
