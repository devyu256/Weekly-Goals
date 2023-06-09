//
//  Model.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/05.
//　データ保存と編集処理
//

import Foundation
import SwiftUI
import CoreData

class Model : ObservableObject {
    @Published var id = UUID()
    @Published var title = ""
    @Published var days = 0
    @Published var weeks = 0
    @Published var regYear = 0
    @Published var regWeek = 0
    @Published var regDate = ""
    @Published var goal = 0
    @Published var date = Date()
    @Published var serial = 0
    @Published var fromDate = ""
    @Published var resetYear = 0
    @Published var resetWeek = 0
    
    @Published var isNewData = false
    @Published var updateItem : Card!
    
    func writeData(context :NSManagedObjectContext){
        
        //データが新規か編集かで処理を分ける
        
        if updateItem != nil {
            
            updateItem.title = title
            updateItem.days = Int16(days)
            updateItem.weeks = Int16(weeks)
            updateItem.regYear = Int16(regYear)
            updateItem.regWeek = Int16(regWeek)
            updateItem.regDate = regDate
            updateItem.goal = Int16(goal)
            updateItem.serial = Int16(serial)
            updateItem.fromDate = fromDate
            updateItem.resetYear = Int16(resetYear)
            updateItem.resetWeek = Int16(resetWeek)
            
            try! context.save()
            
            updateItem = nil
            isNewData.toggle()
            
            title = ""
            days = 0
            weeks = 0
            regYear = 0
            regWeek = 0
            regDate = ""
            goal = 0
            serial = 0
            fromDate = ""
            resetYear = 0
            resetWeek = 0

            return
        }
        //新規作成
        
        let newCard = Card(context: context)
        newCard.id = UUID()
        newCard.title = title
        newCard.days = Int16(days)
        newCard.weeks = Int16(weeks)
        newCard.regYear = Int16(regYear)
        newCard.regWeek = Int16(regWeek)
        newCard.regDate = regDate
        newCard.goal = Int16(goal)
        newCard.date = Date()
        newCard.serial = Int16(serial)
        newCard.fromDate = fromDate
        newCard.resetYear = Int16(resetYear)
        newCard.resetWeek = Int16(resetWeek)
        
        do{
            try context.save()
            
            isNewData.toggle()
            
            title = ""
            days = 0
            weeks = 0
            regYear = 0
            regWeek = 0
            regDate = ""
            goal = 0
            date = Date()
            serial = 0
            fromDate = ""
            resetYear = 0
            resetWeek = 0
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    func editItem(item: Card){
        updateItem = item
        
        id = item.wrappedId
        title = item.wrappedTitle
        days = Int(item.wrappedDays)
        weeks = Int(item.wrappedWeeks)
        regYear = Int(item.wrappedRegYear)
        regWeek = Int(item.wrappedRegWeek)
        regDate = item.wrappedRegDate
        goal = Int(item.wrappedGoal)
        serial = Int(item.wrappedSerial)
        fromDate = item.wrappedFromDate
        resetYear = Int(item.wrappedResetYear)
        resetWeek = Int(item.wrappedResetWeek)
        
        isNewData.toggle()
        
    }
}
