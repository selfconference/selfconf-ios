//
//  DateFormatterExtention.swift
//  SelfConference
//
//  Created by Flavius on 5/26/19.
//  Copyright © 2019 Self Conference. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// Returns a shared date formatter.
    @objc(SCC_sharedDateFormatterWithDefaultDateFormat)
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.defaultDateFormatterString
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter
    }()
}
