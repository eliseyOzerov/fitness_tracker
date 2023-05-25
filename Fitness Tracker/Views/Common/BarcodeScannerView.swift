//
//  BarcodeScannerView.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 25/05/2023.
//

import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewRepresentable {
    let session = AVCaptureSession()
    let onCodeDetected: (String) -> Void
    let onCancel: () -> Void
    
    init(onCodeDetected: @escaping (String) -> Void, onCancel: @escaping () -> Void) {
        self.onCodeDetected = onCodeDetected
        self.onCancel = onCancel
    }
    
    func makeUIView(context: Context) -> some UIView {
        // MARK: - Configure the view
        let view = BarcodeScanner()
        
        // MARK: - Configure the input
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return view }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                print("Can't add input")
                return view
            }
        } catch {
            print("Device input doesn't accept given device")
            return view
        }
        
        // MARK: - Configure the output
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code128]
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
        } else {
            print("Can't add output")
            return view
        }
        
        // MARK: - Configure the preview
        view.preview = AVCaptureVideoPreviewLayer(session: session)
        view.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(view.preview)
        
        
        // MARK: - Setup the rest of the UI
        
        // Close button
        
        let closeImage = UIImage(
            systemName: "xmark.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, UIColor.systemGray6.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))])
                .applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24)))
        )
        let closeButton = UIButton.systemButton(with: closeImage!, target: context.coordinator, action: #selector(context.coordinator.closeButtonTapped))
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // MARK: - Start the session
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        let parent: BarcodeScannerView
        
        init(_ parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            print("Received metadataOutput, stopping session")
            parent.session.stopRunning()
            
            if let data = metadataObjects.first {
                guard let readable = data as? AVMetadataMachineReadableCodeObject else { return }
                guard let value = readable.stringValue else { return }
                parent.onCodeDetected(value)
            } else {
                print("Metadata objects empty")
            }
        }
        
        @objc func closeButtonTapped() {
            parent.onCancel()
        }
    }
}

class BarcodeScanner: UIView {
    var preview: AVCaptureVideoPreviewLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update the frame of the preview layer to match the bounds of the view
        preview.frame = self.bounds
    }
}
