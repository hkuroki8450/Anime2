//
//  ViewController.swift
//  Anime2
//
//  Created by 黒木博 on 2019/09/18.
//  Copyright © 2019 Hiroshi Kuroki. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia


// MARK:- レイヤーをAVPlayerLayerにする為のラッパークラス.

class AVPlayerView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

class ViewController: UIViewController {
    // 再生用のアイテム.
    var playerItem : AVPlayerItem!
    
    // AVPlayer.
    var videoPlayer : AVPlayer!
    var path : String?
    var taskNum : Int = 0
    
    struct task {
        var id: Int
        var fileName: String
        var answer: Int
    }
    var tasks = [task]()
    
    @IBAction func buttonPress(_ sender: UIButton) {
        print( "test" )
        print( sender.tag )
        
        if ( sender.tag == tasks[ taskNum ].answer ) {
            print( "正解！" )
        }
        else {
            print( "間違い" )
        }
 
        taskNum = Int.random(in: 0..<2)
        path = Bundle.main.path(forResource: tasks[ taskNum ].fileName, ofType: "mp4")
        doanime()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tasks.append( task(id: 1 ,fileName: "tori1", answer: 2 ))
        tasks.append( task(id: 2 ,fileName: "tori2", answer: 1 ))
        
        print( tasks )
        
        taskNum = Int.random(in: 0..<2)
        path = Bundle.main.path(forResource: tasks[ taskNum ].fileName, ofType: "mp4")
        doanime()
    }

    func doanime () {
        let fileURL = URL(fileURLWithPath: path!)
        let avAsset = AVURLAsset(url: fileURL)
        
        // AVPlayerに再生させるアイテムを生成.
        playerItem = AVPlayerItem(asset: avAsset)
        
        // AVPlayerを生成.
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        // Viewを生成.
        let videoPlayerView = AVPlayerView(frame:  self.view.bounds)
        
        // 大きさを変える方法
        videoPlayerView.frame = CGRect(x : 30, y : 20, width : 704, height : 528)
        
        // UIViewのレイヤーをAVPlayerLayerにする.
        let layer = videoPlayerView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer
        
        // レイヤーを追加する.
        self.view.layer.addSublayer(layer)
        
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
}

