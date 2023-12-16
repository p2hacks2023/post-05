//
//  QRgenerate.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI

struct QRCodeGenerator {

    func generate(with inputText: String) -> UIImage? {

        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        else { return nil }

        let inputData = inputText.data(using: .utf8)
        qrFilter.setValue(inputData, forKey: "inputMessage")
        // 誤り訂正レベルをHに指定
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")

        guard let ciImage = qrFilter.outputImage
        else { return nil }

        // CIImageは小さい為、任意のサイズに拡大
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCiImage = ciImage.transformed(by: sizeTransform)

        // CIImageだとSwiftUIのImageでは表示されない為、CGImageに変換
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledCiImage,
                                                  from: scaledCiImage.extent)
        else { return nil }

        return UIImage(cgImage: cgImage).composited(withSmallCenterImage: UIImage(named: "icon1")!)
    }
}


struct QRScreen: View {
    @State var mydata : UserInfo
    @ObservedObject private var viewModel = ViewModel()
    @State private var qrCodeImage: UIImage?
    private let qrCodeGenerator = QRCodeGenerator()

    
    var body: some View {
        
        ZStack(){
            
            //背景
            Image("screen_background")
                .opacity(0.5)
            
            //画面タイトル
            ScreenTitle(title: "Exchange")
            
            VStack(spacing: 16) {
                
                if let qrCodeImage = qrCodeImage { // 正しい構文
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .frame(maxWidth: card_width/1.5, maxHeight: card_width/1.5, alignment: .top)

                } else {
                    ReloadButton {
                        qrCodeImage = qrCodeGenerator.generate(with: mydata.id)
                    }//.frame(maxHeight: .infinity, alignment: .top)
                }

                Text("Hello, QRCode!")
            }
        }
    }
}

struct ReloadButton: View {

    let action: () -> Void

    var body: some View {

        VStack {
            Text("データを取得出来ませんでした")

            Button {
                action()
            } label: {
                Text("再取得")
                Image("arrow.counterclockwise")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
}
