//
//  String+HTMLTagConverter.swift
//  SelfConference
//
//  Created by Flavius on 5/26/19.
//  Copyright © 2019 Self Conference. All rights reserved.
//

import Foundation

///  A tuple which represents a HTML tag and its respective replacement text (newValue).
private typealias Replacement = (tag: String, newValue: String )

extension String {
    
    /// Returns a new string which replaces HMTL tags with the appropriate visual text representation
    ///
    /// - Returns: A new string with certain HTML tags removed.
    func convertedHTMLTags() -> String {
        let replacements = [Replacement(tag: "<br />", newValue: "\n"),
                            Replacement(tag: "<br/>", newValue: "\n"),
                            Replacement(tag: "<ul>", newValue: "\n"),
                            Replacement(tag: "</ul>", newValue: "\n"),
                            Replacement(tag: "<li>", newValue: "• "),
                            Replacement(tag: "</li>", newValue: "\n"),
                            Replacement(tag: "<a href=\"", newValue: ""),
                            Replacement(tag: "\">", newValue: " ("),
                            Replacement(tag: "</a>", newValue: ")")]
        
        var replacementString = self
        
        replacements.forEach { replacement in
            replacementString = replacementString.replacingOccurrences(of: replacement.tag,
                                                                       with: replacement.newValue)
        }
        
        return replacementString
    }
}

@objc
extension NSString {
    
    /// Returns a new string which replaces HMTL tags with the appropriate visual text representation
    ///
    /// - Returns: A new string with certain HTML tags removed.
    /// - Attention: This function can be removed when no Obj-C code calls it.
    func SC_convertedHTMLTagString() -> NSString {
        let swiftString = self as String
        return swiftString.convertedHTMLTags() as NSString
    }
}
