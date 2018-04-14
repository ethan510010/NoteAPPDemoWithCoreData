//
//  Note+CoreDataProperties.swift
//  RecordDemoWithCoreData
//
//  Created by EthanLin on 2018/4/14.
//  Copyright © 2018年 EthanLin. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var title: String?
    @NSManaged public var noteImages: NSSet?

}

// MARK: Generated accessors for noteImages
extension Note {

    @objc(addNoteImagesObject:)
    @NSManaged public func addToNoteImages(_ value: Photo)

    @objc(removeNoteImagesObject:)
    @NSManaged public func removeFromNoteImages(_ value: Photo)

    @objc(addNoteImages:)
    @NSManaged public func addToNoteImages(_ values: NSSet)

    @objc(removeNoteImages:)
    @NSManaged public func removeFromNoteImages(_ values: NSSet)

}
