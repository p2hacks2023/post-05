//
//  AnyParts.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/11.
//

import SwiftUI

struct ScreenTitle: View {
    let title : String
    var body: some View {
        
        Text(title)
            .frame(width: card_width, height: height, alignment: .topLeading)
            .font(.system(size: width/10))
            .padding(.top, height/6)
            .fontWeight(.heavy)
            .opacity(0.7)
            .foregroundColor(Color.white)
    }
}

import FirebaseAuth

struct LogOutButton: View {
    
    @State var isActive:Bool = false

    var body: some View {
        NavigationView{
            VStack{
                
                NavigationLink(isActive: $isActive,
                destination: {LogInScreen()},
                label: {EmptyView()})
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        isActive = true
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                }, label: {
                    Text("LogOut")
                })
            }.navigationBarBackButtonHidden(true)
        }
    }
}


