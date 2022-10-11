//
//  Entity+CoreDataProperties.swift
//  Reminder App
//
//  Created by GGS-BKS on 24/08/22.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Date?

}

extension Entity : Identifiable {

}
