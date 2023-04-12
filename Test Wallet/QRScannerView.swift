//
//  QRScannerView.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/4/11.
//

import SwiftUI
import AVFoundation

struct QRScannerView: View {
    
    @State var scanResult = "No QR code detected"
    @Binding var shown: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            QRScanner(result: $scanResult, shown: $shown)
            Text(scanResult)
                .padding()
                .background(.black)
                .foregroundColor(.white)
                .padding(.bottom)
        }
    }
}

struct QRScanner: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = QRScannerController
    
    @Binding var result: String
    @Binding var shown: Bool

    func makeUIViewController(context: Context) -> QRScannerController {
        let controller = QRScannerController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanResult: $result, shown: $shown)
    }
}

class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {

    @Binding var scanResult: String
    @Binding var shown: Bool

    init(scanResult: Binding<String>, shown: Binding<Bool>) {
        self._scanResult = scanResult
        self._shown = shown
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            scanResult = "No QR code detected"
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr,
           let result = metadataObj.stringValue {

            scanResult = result
            print(scanResult)
            
            if result.hasPrefix("wc:") {
                myPrint(result)
                shown.toggle()
            }
        }
    }
}
