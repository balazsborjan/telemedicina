//
//  PatientDemo.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 17..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import Foundation

class PatientPOJO {
    
    var name: String!
    
    var sexType: SexType!
    
    var birthDate: Date!
    
    var TAJ: String!
    
    init(name: String!, sexType: SexType!, birthDate: Date!, TAJ: String!) {
        self.name = name
        self.sexType = sexType
        self.birthDate = birthDate
        self.TAJ = TAJ
    }
    
    init() {}
    
    func equalsWithPatient(patient: Patient) -> Bool {
        
        return self.name == patient.name! &&
            (self.birthDate as NSDate?)! == patient.birthDate &&
            Int32(self.sexType.hashValue) == patient.sexType &&
            self.TAJ == patient.taj
    }
}

enum SexType {
    case No
    case Ferfi
}
