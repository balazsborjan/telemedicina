//
//  PatientValidator.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 18..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import Foundation

class PatientValidator {
    
    static let nameRegex = "^[A-ZÁÉÓÚÜŰÖŐÍ][a-záéóúüűöőí]+ [A-ZÁÉÓÚÜŰÖŐÍ][a-záéóúüűöőí]+[ [A-ZÁÉÓÚÜŰÖŐÍ][a-záéóúüűöőí]+]*"
    static let tajRegex = "^[1-9][0-9]{8}"
    
//    func validate(patient: PatientPOJO) -> Int {
//        
//        if patient.name != nil && patient.birthDate != nil && patient.sexType != nil && patient.TAJ != nil {
//            
//            if !isValid(name: patient.name!) {
//                
//                return 1
//            }
//            
//            if !isValid(TAJ: patient.TAJ) {
//                
//                return 2
//            }
//            
//            return 0
//        }
//        
//        return -1
//    }
    
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
            
            if taj.characters.count != 9 {
                
                return false
            }
            
            var tempString = taj
            tempString?.characters.removeLast()
            
            var count = 0.0
            var newNum = 0.0
            
            for i in 0..<8 {
                
                if let firstNumberChar = Double(String(describing: tempString!.characters.first!)) {
                    
                    if (i + 1) % 2 == 0 {
                            
                        newNum = firstNumberChar * 7
                            
                    } else {
                            
                        newNum = firstNumberChar * 3
                    }
                    
                    count = count + newNum
                    
                } else {
                        
                    return false
                }
                    
                tempString?.characters.removeFirst()
            }
            
            newNum = count.truncatingRemainder(dividingBy: 10.0)
            
            return taj.characters.last == String(newNum).characters.first
        }
        
        return false
    }
}
