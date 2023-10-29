//
//  Diary+CoreDataProperties.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/28.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var japanese: String?
    @NSManaged public var english: String?
    @NSManaged public var situation: String?
    @NSManaged public var wantToSay: String?
    @NSManaged public var id: String?

}

extension Diary : Identifiable {

}
