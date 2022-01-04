//
//  SecondViewController.swift
//  CovidTrack
//
//  Created by Bryan on 2021/12/30.
//

import UIKit
import AVFoundation

class SecondChildViewController: UIViewController {
    
    //Capture Session
    //Photo output
    //video Preview
    //shutter button
    
    var session : AVCaptureSession?
    let outPut = AVCapturePhotoOutput()
    let preview = AVCaptureVideoPreviewLayer()
    let shutterButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.brown.cgColor
//        button.layer.masksToBounds = true

        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.layer.addSublayer(preview)
        view.addSubview(shutterButton)
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    @objc private func didTapTakePhoto (){
        outPut.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preview.frame = view.bounds
        shutterButton.frame = CGRect(x: (view.frame.width - shutterButton.frame.width) / 2, y: (view.frame.width - shutterButton.frame.height) / 2 + 400, width: 100, height: 100)
//        shutterButton.center = CGPoint(x: view.frame.size.width / 2, y: (view.frame.size.height) / 2 + 300)
        

    }
    
    private func checkCameraPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else{return}
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera(){
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                if session.canAddOutput(outPut){
                    session.addOutput(outPut)
                }
                preview.videoGravity = .resizeAspectFill
                preview.session = session
                session.startRunning()
                self.session = session
            }catch{
                
            }
        }
    }
    

}

extension SecondChildViewController:AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {return}
        
        let image = UIImage(data: data)
        
        session?.stopRunning()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.inputAccessoryView?.bounds ?? view.bounds
        view.addSubview(imageView)
        
    }
}
