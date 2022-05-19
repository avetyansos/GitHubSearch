//
//  DateString+ToCorrectString.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/19/22.
//

import Foundation


extension String {
    
    func toCorrectDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
}
