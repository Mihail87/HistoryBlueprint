//
//  Events.swift
//  History Blueprint
//
//  Created by Mihai Leonte on 12/3/17.
//  Copyright © 2017 Mihai Leonte. All rights reserved.
//

import Foundation

protocol EventItemQuiz {
    var name: String { get }
    var date: Date { get }
    var link: String { get }
}

protocol EventsGameQuiz {
    var maxRounds: Int { get }
    var events: [Event] { get set }
    var currentRound: Int { get set }
    
    init(events: [Event])
    func isGameOver() -> Bool
    func newRound() throws -> [Event]
}

struct Event: EventItemQuiz {
    let name: String
    let date: Date
    let link: String
}

class QuizGame: EventsGameQuiz {
    let maxRounds: Int = 7
    var currentRound: Int = 0
    var currentScore: Int = 0
    var events: [Event]
    
    required init(events: [Event]) {
        currentRound += 1
        self.events = events
    }
    
    func isGameOver() -> Bool {
        if currentRound < maxRounds {
            return false
        } else {
            return true
        }
    }
    
    func newRound() throws -> [Event] {
        // FIXME: Return 4 random events
        return self.events
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






























