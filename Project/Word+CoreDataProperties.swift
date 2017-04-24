//
//  Word+CoreDataProperties.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 04. 24..
//  Copyright © 2017. SZTE. All rights reserved.
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var category: String?
    @NSManaged public var data: String?

}
