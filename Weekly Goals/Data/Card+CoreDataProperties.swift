//
//  Card+CoreDataProperties.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/05.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var days: Int16
    @NSManaged public var weeks: Int16
    @NSManaged public var regYear: Int16
    @NSManaged public var regWeek: Int16
    @NSManaged public var regDate: String?
    @NSManaged public var goal: Int16
    @NSManaged public var date: Date?
    @NSManaged public var serial: Int16

}

//nilの場合の処理を追加
extension Card {
    public var wrappedId:UUID {id ?? UUID()}
    public var wrappedTitle: String {title ?? ""}
    public var wrappedDays: Int16 {days}
    public var wrappedWeeks: Int16 {weeks}
    public var wrappedRegYear: Int16 {regYear}
    public var wrappedRegWeek: Int16 {regWeek}
    public var wrappedRegDate: String {regDate ?? ""}
    public var wrappedGoal: Int16 {goal}
    public var wrappedDate: Date {date ?? Date()}
    public var wrappedSerial: Int16 {serial}
}

extension Card : Identifiable {

}
