//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var mainLabel: UILabel!
    
    //MARK: Constants & Variables
    let eggTimes = ["Soft": 1, "Medium": 7, "Hard": 12]
    var time: Int?
    var timer: Timer?
    var totalTime: Int = 0
    var secondsPass: Int = 0
    var hardness: String?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        mainLabel.text = "How do you like your eggs?"
        progressBar.progress = 0.0
        percentageLabel.text = ""
    }
    
    //MARK: IBActions
    @IBAction func hardnessSelected(_ sender: UIButton) {
        print(sender.titleLabel ?? "Unknown Button Pressed.")
        timer?.invalidate()
        progressBar.progress = 0.0
        percentageLabel.text = "0%"
        
        hardness = sender.titleLabel?.text
        
        totalTime = eggTimes[hardness ?? "Soft"] ?? 0
        totalTime *= 60
        print(totalTime)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        mainLabel.text = "\(eggTimes[hardness ?? "Soft"]!) Minute Timer Selected"
    }
    
    @objc func updateTimer() {
        if totalTime - secondsPass > 0 {
            print("\(totalTime - secondsPass) seconds.")
            secondsPass += 1
            let percentageProgress = Float(secondsPass) / Float(totalTime)
            progressBar.progress = percentageProgress
            percentageLabel.text = "\(Int(percentageProgress * 100))%"
            
        } else {
            timer?.invalidate()
            mainLabel.text = "Eggs are done!"
            percentageLabel.text = ""
            playAlarm()
        }
    }
    
    private func playAlarm() {
        guard let path = Bundle.main.path(forResource: "alarm_sound", ofType: ".mp3") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
