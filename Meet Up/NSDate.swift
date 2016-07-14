//
//  NSDate.swift
//  Note
//
//  Created by Thong Tran on 6/22/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import Foundation

extension NSDate {
    func convertToString() -> String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
}


class DateFormatter {
    
    
    static func convertDate( date: String) -> String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date)
        
        
        dateFormatter.dateFormat = "MMM d, H:mm a"///this is you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        return timeStamp
    }
}