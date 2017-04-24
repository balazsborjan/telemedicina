//
//  Result+CoreDataProperties.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 04. 24..
//  Copyright © 2017. SZTE. All rights reserved.
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var point: Int32
    @NSManaged public var normative: String?
    @NSManaged public var personal: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var patient: Patient?

}
