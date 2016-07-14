//
//  eventHelper.swift
//  Meet Up
//
//  Created by Thong Tran on 7/13/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import Foundation
import SwiftyJSON
struct event {
    
    let topicOfEvent : String
    let timeOfEvent : String
    let locationOfEvent: String
    let url: String
    //let description: String!
    let image: String!
    
    init (json: JSON )
    {
        self.topicOfEvent = json["name"]["text"].stringValue
            //self.description = json["description"]["text"].stringValue
        self.timeOfEvent = (json["start"]["local"].stringValue)
        self.url = json["url"].stringValue
        self.image = json["logo"]["url"].stringValue
        self.locationOfEvent = "\(json["venue"]["address"]["address_1"].stringValue)\n \(json["venue"]["address"]["city"].stringValue) \(json["venue"]["address"]["region"].stringValue) \(json["venue"]["address"]["postal_code"].stringValue)"
    }
    
    
    
}
