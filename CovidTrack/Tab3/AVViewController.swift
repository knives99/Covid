//
//  AVViewController.swift
//  CovidTrack
//
//  Created by Bryan on 2022/1/17.
//

import UIKit
import AVFoundation
import AVKit

class AVViewController: UIViewController {
    
    var playItem : AVPlayerItem?
    let controller = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
//        getAVVC()
        getAVVC2()

    }
    
    func getAVVC(){
        guard let url = URL(string: "https://archive.org/download/turner_video_107883/107883.mp4") else {return}

        let player = AVPlayer(url: url)

        let asset = AVAsset(url: url)
//        ler asset = AVURLAsset(url: <#T##URL#>)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true, completion: nil)
        player.play()


//        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        let playerItem = AVPlayerItem(url: url)
//        playerItem.asset.duration
        playerItem.duration
        print(asset.duration)
    }
    
    func getAVVC2(){
        let asset = AVAsset(url: URL(string: "https://archive.org/download/turner_video_107883/107883.mp4")!)
        playItem = AVPlayerItem(asset: asset)
        controller.player = AVPlayer(playerItem: playItem)
        present(controller, animated: true) {
            self.controller.player?.play()
            NotificationCenter.default.post(name: Notification.Name("ABC"), object: nil)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(keyPath)
        if keyPath == "A"{
            print("1234")
        }
    }
    
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(keyPath)
    }
    
    
    


}
