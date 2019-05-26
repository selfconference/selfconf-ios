//
//  Constants.swift
//  SelfConference
//
//  Created by Flavius on 5/26/19.
//  Copyright © 2019 Self Conference. All rights reserved.
//

import Foundation

// Obj-C does not interop with enums or structs, this class is used as a constants storage. Once the project is fully converted to swift, this object can be converted to an enum. At that point the init method and @objc annotations can also be removed.

class Constants: NSObject {
    // Preventing this class from being initalized
    private override init() {}
    
    @objc
    static let defaultDateFormatterString = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
}
