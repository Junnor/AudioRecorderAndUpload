//
//  ViewController.swift
//  AudioRecorderAndUpload
//
//  Created by ju on 2017/7/19.
//  Copyright © 2017年 ju. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var session: AVAudioSession!

    private var recorder: AVAudioRecorder!
    private var player: AVAudioPlayer!
    
    private var pcmPath: String!
    private var mp3FilePath: String!
    
    private var recorderSetting: [String: AnyObject]!
    
    private var mp3FileURL: URL!
    
    private let avSampleRateKey = 44100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVAudioSession.sharedInstance()
        try! session.setActive(true)
        
        let docDic = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        pcmPath = docDic + "/play.pcm"
        mp3FilePath = docDic + "/play.mp3"
        
        mp3FileURL = URL(fileURLWithPath: mp3FilePath)
        
        recorderSetting =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
                AVNumberOfChannelsKey: 2 as AnyObject, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue as AnyObject,
                AVEncoderBitRateKey : 640000 as AnyObject,
                AVSampleRateKey : avSampleRateKey as AnyObject //录音器每秒采集的录音样本数
        ]
    }
    
    
    @IBAction func touchDown() {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            recorder = try AVAudioRecorder(url: URL(string: pcmPath)!, settings: recorderSetting)
            recorder.isMeteringEnabled = true
            recorder.record()
        } catch let error {
            print("create recorder error: \(error)")
        }
    }
    
    @IBAction func touchUp() {
        recorder.stop()
        
        DispatchQueue.global().async {
            let success = AudioTransform.transformToMp3(fromPath: self.pcmPath,
                                                        toMp3Path: self.mp3FilePath,
                                                        withAVSampleRateKey: Int32(self.avSampleRateKey))
            
            DispatchQueue.main.async {
                print("transform success")
                if success {
                    do {
                        let data = try Data(contentsOf: self.mp3FileURL!)
                        print("data: \(data)")
                        DemoModel.uploadRecord(data: data) { (success, info) in
                            
                        }
                    } catch let error {
                        print("upload audio error: \(error)")
                    }
                }
            }
        }
    }
    
    @IBAction func play() {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
            player = try AVAudioPlayer(contentsOf: recorder.url)
            player.play()
        } catch let error {
            print("paly audio error: \(error)")
        }
    }
}
