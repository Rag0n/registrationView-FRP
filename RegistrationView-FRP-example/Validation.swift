//
//  Validation.swift
//  RegistrationView-FRP-example
//
//  Created by Александр on 21.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

extension String {
    func contains(substring: String) -> Bool {
        return (self as NSString).containsString(substring)
    }
    
    func contains(substrings: [String]) -> Bool {
        return substrings.reduce(true) { (memo, substring) -> Bool in
            return memo && contains(substring)
        }
    }
}

func isValidEmail(text: String) -> Bool {
    return text.contains(["@", "."])
}

func isValidPassword(text: String) -> Bool {
    return text.characters.count > minimalPasswordlength
}

let minimalPasswordlength = 6
