//
//  QRScan.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/15.
//

import SwiftUI
import AVFoundation

struct QRScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRScannerView

        init(parent: QRScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.didFindCode(stringValue)
            }
        }
    }

    var didFindCode: (String) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()

        guard let device = AVCaptureDevice.default(for: .video) else { return viewController }
        let input = try? AVCaptureDeviceInput(device: device)

        if let input = input {
            session.addInput(input)
        } else {
            return viewController
        }

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        session.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct QRScan: View {
    @ObservedObject private var myVM = ViewModel()
    @State private var scannedCode: String?

    var body: some View {
        VStack {
            if let scannedCode = scannedCode {
                myVM.addFriend()
                //myVM.fetchFireStore()
                //Text("Scanned Code: \(scannedCode)")
            } else {
                QRScannerView { code in
                    self.scannedCode = code
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

