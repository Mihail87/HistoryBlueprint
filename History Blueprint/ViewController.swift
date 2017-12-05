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
    
    
    var eventsGame: QuizGame

    // FIXME: Is this required?
    //required init?(coder aDecoder: NSCoder) {
    //  // If so move the init of the eventsGame in here
    //  super.init(coder: aDecoder)
    //}
    
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
    
    func configureUI {
        eventLabel1.layer.cornerRadius = 5
        eventLabel1.layer.masksToBounds = true
        eventLabel2.layer.cornerRadius = 5
        eventLabel2.layer.masksToBounds = true
        eventLabel3.layer.cornerRadius = 5
        eventLabel3.layer.masksToBounds = true
        eventLabel4.layer.cornerRadius = 5
        eventLabel4.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

