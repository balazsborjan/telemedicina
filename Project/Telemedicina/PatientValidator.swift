//
//  PatientValidator.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 18..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import Foundation

class PatientValidator {
    
    static let nameRegex = "^[A-Z]'?[- a-zA-Z]( [a-zA-Z])*$"
    static let tajRegex = "^[1-9][0-9]{8}"
    
    class func isValid(name: String!) -> Bool {
        
        if name.range(of: nameRegex, options: .regularExpression, range: nil, locale: nil) != nil {
            return true
        }
        
        return false
    }
    
    class func isValid(TAJ taj: String!) -> Bool {
        
        if taj.range(of: tajRegex, options: .regularExpression, range: nil, locale: nil) != nil {
            
            // Utolsó számjegy szabálya: páratlan pozicion lévőket 3-al pároson lévőket 7-tel szorozni, 
            // ezeket szummázni, ezt osztani 10-el, maradék az utolsó számjegy
            return true
        }
        
        return false
    }
}
