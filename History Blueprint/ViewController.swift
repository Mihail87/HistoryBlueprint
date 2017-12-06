//
//  ViewController.swift
//  History Blueprint
//
//  Created by Mihai Leonte on 12/3/17.
//  Copyright © 2017 Mihai Leonte. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var eventLabel1: UILabel!
    @IBOutlet weak var eventLabel2: UILabel!
    @IBOutlet weak var eventLabel3: UILabel!
    @IBOutlet weak var eventLabel4: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var eventButton1_down: UIButton!
    @IBOutlet weak var eventButton2_up: UIButton!
    @IBOutlet weak var eventButton2_down: UIButton!
    @IBOutlet weak var eventButton3_up: UIButton!
    @IBOutlet weak var eventButton3_down: UIButton!
    @IBOutlet weak var eventButton4_up: UIButton!
    
    
    
    var eventsGame: QuizGame
    var timer: Timer?
    var timerCounter = 60
    var player: AVAudioPlayer?

    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "EventsList", ofType: "plist")
            let events = try EventsUnarchiver.eventsList(fromDictionary: dictionary)
            self.eventsGame = QuizGame(events: events)
        } catch let error {
            fatalError("Fatal error: \(error)")
        }

        super.init(coder: aDecoder)
    }
    
    func configureUI(withRadius radius: CGFloat) {
        eventLabel1.layer.cornerRadius = radius
        eventLabel1.layer.masksToBounds = true
        eventLabel2.layer.cornerRadius = radius
        eventLabel2.layer.masksToBounds = true
        eventLabel3.layer.cornerRadius = radius
        eventLabel3.layer.masksToBounds = true
        eventLabel4.layer.cornerRadius = radius
        eventLabel4.layer.masksToBounds = true
    }
    
    @objc func updateTimer() {
        if timerCounter > 0 {
            timerCounter -= 1
            timerLabel.text = String(timerCounter)
        } else {
            checkRound()
        }
    }
    
    func restartTimer() {
        timerCounter = 60
        timerLabel.text = String(timerCounter)
        timer?.invalidate()
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for Shake gesture detection - Let iOS know which view controller is the first in the responder chain:
        self.becomeFirstResponder()
        // round cornered Labels
        configureUI(withRadius: 5)
        
        // start new game
        startTimer()
        eventsGame.newRound()
        refreshLabels()
        
        eventButton1_down.setBackgroundImage(#imageLiteral(resourceName: "down_full_selected"), for: UIControlState.highlighted)
        
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: dismissAlert)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissAlert(sender: UIAlertAction) -> Void {
        eventsGame.newGame()
        refreshLabels()
        roundLabel.text = "Round 1"
        restartTimer()
    }
    
    func refreshLabels() {
        eventLabel1.text = eventsGame.events[0].name
        eventLabel2.text = eventsGame.events[1].name
        eventLabel3.text = eventsGame.events[2].name
        eventLabel4.text = eventsGame.events[3].name
    }
    
    func checkRound() {
        eventsGame.checkRound()
        refreshLabels()
        if eventsGame.isGameOver() {
            showAlertWith(title: "Game over", message: "You've won \(eventsGame.currentScore) rounds")
            timer?.invalidate()
        } else {
            roundLabel.text = "Round \(eventsGame.currentRound)"
            restartTimer()
        }
    }
    
    // for Shake gesture detection
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if let newEvent = event {
            if(newEvent.subtype == UIEventSubtype.motionShake) {
                checkRound()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Swaps events and labels for the first 2 Labels
    func swap_01() {
        eventsGame.events.swapAt(0, 1)
        refreshLabels()
    }
    
    func playClickSound() {
        if let asset = NSDataAsset(name: "clickSound") {
            do {
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: "wav")
                player?.play()
            } catch let error {
                print("\(error)")
            }
        }
    }

    @IBAction func moveLabel1_down() {
        swap_01()
        playClickSound()
    }
    @IBAction func moveLabel2_up() {
        swap_01()
        playClickSound()
    }
  
    
    // Swaps events and labels for the second and third Label
    func swap_12() {
        eventsGame.events.swapAt(1, 2)
        refreshLabels()
    }
    @IBAction func moveLabel2_down() {
        swap_12()
        playClickSound()
    }
    @IBAction func moveLabel3_up() {
        swap_12()
        playClickSound()
    }
    
    func swap_23() {
        eventsGame.events.swapAt(2, 3)
        refreshLabels()
    }
    @IBAction func moveLabel3_down() {
        swap_23()
        playClickSound()
    }
    @IBAction func moveLabel4_up() {
        swap_23()
        playClickSound()
    }

    
}

