//
//  Events.swift
//  History Blueprint
//
//  Created by Mihai Leonte on 12/3/17.
//  Copyright © 2017 Mihai Leonte. All rights reserved.
//

import Foundation
import GameKit

protocol EventItemQuiz {
    var name: String { get }
    var date: Date { get }
    var link: String { get }
}

protocol EventsGameQuiz {
    var maxRounds: Int { get }
    var events: [Event] { get set }
    var currentRound: Int { get set }
    var currentScore: Int { get set }
    
    init(events: [Event])
    func isGameOver() -> Bool
    func newRound()
    func checkRound()
}

struct Event: EventItemQuiz {
    let name: String
    let date: Date
    let link: String
}

class QuizGame: EventsGameQuiz {
    let maxRounds: Int = 3
    var currentRound: Int = 0
    var currentScore: Int = 0
    var events: [Event]
    
    required init(events: [Event]) {
        self.events = events
    }
    
    func isGameOver() -> Bool {
        if currentRound <= maxRounds {
            return false
        } else {
            return true
        }
    }
    
    func newRound() {
        // Shuffle the Events array -> O(n) complexity and O(1) additional space
        var last = events.count - 1
        while(last > 0)
        {
            let rand = GKRandomSource.sharedRandom().nextInt(upperBound: last)
            events.swapAt(last, rand)
            last -= 1
        }
        self.currentRound += 1
    }
    
    func checkRound() {
        if events[0].date < events[1].date && events[1].date < events[2].date && events[2].date < events[3].date{
            self.currentScore += 1
        }
        if !isGameOver() {
            newRound()
        }
    }
    
    func newGame() {
        self.currentRound = 0
        self.currentScore = 0
        
        newRound()
    }
}

enum EventsError: Error {
    case invalidResource
    case conversionFailure
}

class PlistConverter {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw EventsError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw EventsError.conversionFailure
        }
        
        return dictionary
    }
}

class EventsUnarchiver {
    static func eventsList(fromDictionary dictionary: [String: AnyObject]) throws -> [Event] {
        var events: [Event] = []
        
        for (key, value) in dictionary {
            if let eventDictionary = value as? [String: Any], let link = eventDictionary["link"] as? String, let date = eventDictionary["date"] as? Date {
                let newEvent = Event(name: key, date: date, link: link)
                
                events.append(newEvent)
            }
        }
        
        return events
    }
}






























