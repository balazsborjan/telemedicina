//
//  Patient+CoreDataProperties.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 04. 24..
//  Copyright © 2017. SZTE. All rights reserved.
//

import Foundation
import CoreData


extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }

    @NSManaged public var name: String?
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var taj: String?
    @NSManaged public var sexType: Int32
    @NSManaged public var results: NSSet?

}

// MARK: Generated accessors for results
extension Patient {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: Result)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: Result)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}
