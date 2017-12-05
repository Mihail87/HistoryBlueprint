//
//  ViewController.swift
//  History Blueprint
//
//  Created by Mihai Leonte on 12/3/17.
//  Copyright © 2017 Mihai Leonte. All rights reserved.
//

import UIKit

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

//    if timer == nil {
//        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(hideNumResultLabel), userInfo: nil, repeats: false)
//    } else {
//        timer?.fire()
//    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for Shake gesture detection - Let iOS know which view controller is the first in the responder chain:
        self.becomeFirstResponder()
        
        configureUI(withRadius: 5)
        
        do {
            try eventsGame.newRound()
            eventLabel1.text = eventsGame.events[0].name
            eventLabel2.text = eventsGame.events[1].name
            eventLabel3.text = eventsGame.events[2].name
            eventLabel4.text = eventsGame.events[3].name
        } catch let error {
            fatalError("\(error)")
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: dismissAlert)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissAlert(sender: UIAlertAction) -> Void {
        // FIXME: restart game
    }
    
    func refreshLabels() {
        eventLabel1.text = eventsGame.events[0].name
        eventLabel2.text = eventsGame.events[1].name
        eventLabel3.text = eventsGame.events[2].name
        eventLabel4.text = eventsGame.events[3].name
    }
    
    // for Shake gesture detection
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if let newEvent = event {
            if(newEvent.subtype == UIEventSubtype.motionShake) {
                eventsGame.checkRound()
                refreshLabels()
                if eventsGame.isGameOver() {
                    showAlertWith(title: "Game over", message: "You've won \(eventsGame.currentScore) rounds")
                } else {
                    roundLabel.text = "Round \(eventsGame.currentRound)"
                }
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
    @IBAction func moveLabel1_down() {
        swap_01()
    }
    @IBAction func moveLabel2_up() {
        swap_01()
    }
    
    // Swaps events and labels for the second and third Label
    func swap_12() {
        eventsGame.events.swapAt(1, 2)
        refreshLabels()
    }
    @IBAction func moveLabel2_down() {
        swap_12()
    }
    @IBAction func moveLabel3_up() {
        swap_12()
    }
    
    func swap_23() {
        eventsGame.events.swapAt(2, 3)
        refreshLabels()
    }
    @IBAction func moveLabel3_down() {
        swap_23()
    }
    @IBAction func moveLabel4_up() {
        swap_23()
    }
    
}

