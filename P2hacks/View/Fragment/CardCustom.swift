//
//  CardCustom.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI
import RealmSwift

struct UpDataBUtton: View {
    @ObservedObject private var myVM = ViewModel()
    @Binding var myCard : UserInfo
    @State var color  = Color.blue
    //デフォルトRealmの取得
    let realm = try! Realm()
    
    var body: some View {
        Button(action: {
            myCard.id = myVM.getUserID()
            myVM.writeFireStore(data: myCard)
            color = Color.gray
            let aaa = transformDB(data: myCard)
            do{
              try realm.write{
                  realm.deleteAll()
                  realm.add(aaa)
              }
            }catch {
              print("Error \(error)")
            }

        }) {
            Image(systemName: "gobackward")
            Text("更新")
                .foregroundColor(Color.black)
        }
        .frame(width: 80,height: 50)
        .background(color)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

struct CustomText: View {
    @Binding var user : String
    let title : String
    let field : String
    let height : CGFloat
    
    var body: some View {
        VStack(spacing: 10){
            Text(title)
                .frame(width:card_width/1.1, alignment: .leading)
                .fontWeight(.black)
            TextField(field, text: $user)
                .frame(width: card_width/1.5, height: height, alignment: .center)
                .padding(.horizontal, 15)
                .background(Color.white)
                .cornerRadius(30)
                .opacity(0.8)
            Spacer()
        }.padding(.bottom, 5)
    }
}

struct CustomNum: View {
    @Binding var user : Int
    let title : String
    let field : String
    let height : CGFloat
    
    var body: some View {
        VStack(spacing: 10){
            Text(title)
                .frame(width:card_width/1.1, alignment: .leading)
                .fontWeight(.black)
            
            TextField(field, value: $user, format: .number)
                .keyboardType(.numberPad) // 数字のみ
                .frame(width: card_width/1.5, height: height, alignment: .center)
                .padding(.horizontal, 15)
                .background(Color.white)
                .cornerRadius(30)
                .opacity(0.8)
            Spacer()
        }.padding(.bottom, 5)
    }
}

struct BackCell: View {
    @Binding var back : String
    let background: String
    var body: some View {
        Image(background)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onTapGesture {
                back = background
            }
    }
}

struct AvaterCell: View {
    @Binding var avater : String
    let ava: String
    var body: some View {
        Image(ava)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onTapGesture {
                avater = ava
            }
    }
}

struct CustomIcon: View {
    @Binding var avater : String
    let avaterList = ["myicon", "icon1", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8", "icon9", "icon10"]
    let columns : Int = 4
    
    var body: some View {
        
        VStack(spacing: 10){
            Text("アイコン")
                .frame(width:card_width/1.1, alignment: .leading)
                .fontWeight(.black)
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    ForEach(0..<self.avaterList.count/self.columns) { rowIndex in
                        HStack {
                            ForEach(0..<self.columns) { columnIndex in
                                self.getAvaterCell(
                                    avater: self.getAvater(rowIndex: rowIndex, columnIndex: columnIndex),
                                    width: self.cellWidth(width: geometry.size.width),
                                    height: self.cellHeight(width: geometry.size.width))
                            }
                        }
                    }
                    if (self.avaterList.count % self.columns > 0) {
                        HStack {
                            ForEach(0..<self.avaterList.count % self.columns) { lastColumnIndex in
                                self.getAvaterCell(
                                    avater: self.getAvater(lastColumnIndex: lastColumnIndex),
                                    width: self.cellWidth(width: geometry.size.width),
                                    height: self.cellHeight(width: geometry.size.width))
                            }
                            Spacer()
                                }
                            }
                        }
                    }.padding()
        }.frame(width: card_width/1.1, height: 160, alignment: .center)
        
            Spacer()
        }
    

    private func getAvater(rowIndex: Int, columnIndex: Int) -> String {
        return avaterList[columns * rowIndex + columnIndex]
        }
    private func getAvater(lastColumnIndex: Int) -> String {
        return self.avaterList[self.columns * (self.avaterList.count / self.columns) + lastColumnIndex]
        }
    private func cellWidth(width: CGFloat) -> CGFloat {
        return width / CGFloat(columns)
        }
    private func cellHeight(width: CGFloat) -> CGFloat {
        return cellWidth(width: width)
        }
    private func getAvaterCell(avater: String, width: CGFloat, height: CGFloat) -> AnyView {
        return AnyView(AvaterCell(avater: $avater ,ava: avater)
                .frame(width: width,
                       height: height)
                .clipped())
        }
}

