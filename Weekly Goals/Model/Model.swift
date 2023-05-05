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
        
        isNewData.toggle()
        
    }
}
