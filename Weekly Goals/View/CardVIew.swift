//
//  CardVIew.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/05.
//データ表示用カードの雛形
//

import Foundation
import SwiftUI

struct CardView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var model : Model
    @ObservedObject var cards : Card
    
    var df = DateFormatter()
    var today = Date()
    
    func startFunc() -> Void {
        
        //        print("start")
        //        print(cards.regDate)
        //        print(cards.regYear)
        //        print(cards.regWeek)
        //        print(cards.days)
        //        print(cards.weeks)
        //
//        cards.regDate = "2023/05/05"
//        cards.regYear = 2023
//        cards.regWeek = 18
//        cards.days = 2
//        cards.weeks = 0
//        cards.goal = 2
//        cards.fromDate = "2023/05/05"
        
        var calendar = Calendar(identifier: .gregorian)
        var lastYearWeekNumber = 0
        var gapWeek = 0
        var todayWeekNumber = 0
        calendar.locale = Locale(identifier: "ja_JP")
        df.dateStyle = .short
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let day = df.string(from: today)
        
        //本日の年、月、日
        let arr:[String] = day.components(separatedBy: "/")
        let component = DateComponents(year: Int(arr[0]), month: Int(arr[1]), day: Int(arr[2]))
        let date = Calendar.current.date(from: component)
        //本日の週数
        todayWeekNumber = calendar.component(.weekOfYear, from: date!)
        //前年の12月31日の週数を計算
        //前年度
        let lastYear = (Int(arr[0]) ?? 9999) - 1
        let lastComponent = DateComponents(year: lastYear, month: 12, day: 31)
        let lastDate = Calendar.current.date(from: lastComponent)
        
        lastYearWeekNumber = calendar.component(.weekOfYear, from: lastDate!)
        //        print(lastYearWeekNumber)
        //週数が1(年始の場合)
        if todayWeekNumber == 1 {
            //前年度である場合
            if cards.regYear == lastYear {
                if cards.regWeek == lastYearWeekNumber {
                    if cards.days >= cards.goal {
                        cards.weeks += 1
                        cards.days = 0
                    } else {
                        cards.weeks = 0
                        cards.days = 0
                        cards.fromDate = ""
                    }
                } else {
                    cards.weeks = 0
                    cards.days = 0
                    cards.fromDate = ""
                }
            } else if cards.regYear == Int16(arr[0]){
                return
            } else {
                cards.weeks = 0
                cards.days = 0
                cards.fromDate = ""
            }
        } else {
            if cards.regYear == Int16(arr[0]) {
                //同年、同週の場合、何もしない
                if cards.regWeek == todayWeekNumber {
                    return
                    //同年、別週
                } else {
                    //週数の差分
                    gapWeek = todayWeekNumber - Int(cards.regWeek)
                    //翌週の場合
                    if gapWeek == 1 {
                        if cards.days >= cards.goal {
                            cards.weeks += 1
                            cards.days = 0
                        } else {
                            cards.weeks = 0
                            cards.days = 0
                            cards.fromDate = ""
                        }
                    } else {
                        cards.weeks = 0
                        cards.days = 0
                        cards.fromDate = ""
                    }
                }
                //別年
            } else {
                cards.weeks = 0
                cards.days = 0
                cards.fromDate = ""
            }
        }
        model.editItem(item: cards)
        model.writeData(context: context)
        
    }
    
    var body: some View {
        //CoreDataに保存されたデータを表示
        VStack {
            HStack{
                Spacer()
                Text(cards.wrappedTitle).foregroundColor(Color.white)
                Spacer()
                Text("Goal - \(cards.wrappedGoal)").foregroundColor(Color.gray)
                Spacer()
            }
            HStack {
                Spacer()
                Text("Continued from \(cards.wrappedFromDate)").foregroundColor(Color.gray)
            }
            HStack{
                Spacer()
                Text("\(cards.wrappedDays) - \(cards.wrappedWeeks)").foregroundColor(Color.white).font(.system(size: 50, weight: .black, design: .default))
                Button(action:{
                    df.dateStyle = .short
                    df.calendar = Calendar(identifier: .gregorian)
                    df.locale = Locale(identifier: "ja_JP")
                    df.timeZone = TimeZone(identifier: "Asia/Tokyo")
                    let day = df.string(from: today)
                    let arr:[String] = day.components(separatedBy: "/")
                    var todayWeekNumber = 0
                    let calendar = Calendar(identifier: .gregorian)
                    let component = DateComponents(year: Int(arr[0]), month: Int(arr[1]), day: Int(arr[2]))
                    let date = Calendar.current.date(from: component)
                    //本日の週数
                    todayWeekNumber = calendar.component(.weekOfYear, from: date!)
                    
                    if day == cards.regDate {
                        //何もしない
                    } else {
                        cards.days += 1
                        cards.regDate = day
                        cards.regYear = Int16(Int(arr[0]) ?? 9999)
                        cards.regWeek = Int16(todayWeekNumber)
                        if cards.days == 1 && cards.weeks == 0 {
                            cards.fromDate = day
                        }
                        model.editItem(item: cards)
                        model.writeData(context: context)
                    }
                }, label:{ Text("")
                    //                        .font(.system(size: 10, weight: .black, design: .default))
                        .padding()
                        .frame(width: 0, height: 0)
                        .background(Color.white)
                    .clipShape(Circle())})
                Spacer()
            }
            //以下、テスト用
            //            Text("regYear - \(cards.wrappedRegYear)").foregroundColor(Color.white)
            //            Text("regWeek - \(cards.wrappedRegWeek)").foregroundColor(Color.white)
            //            Text("regDate - \(cards.wrappedRegDate)").foregroundColor(Color.white)
        }
        .frame(
            minWidth:UIScreen.main.bounds.size.width * 0.7,
            maxWidth: UIScreen.main.bounds.size.width * 0.7,
            minHeight:UIScreen.main.bounds.size.height * 0.1,
            maxHeight: UIScreen.main.bounds.size.height * 0.8
        )
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(Color(.black)))
        //カード長押しで編集と削除のボタンを表示
        .contextMenu{
            Button(action: {
                model.editItem(item: cards)}){
                    Text("Edit")
                    Image(systemName: "pencil")
                        .foregroundColor(Color.black)
                }
            Button(action: {
                context.delete(cards)
                
                try! context.save()}){
                    Text("Delete")
                    Image(systemName: "trash")
                        .foregroundColor(Color.black)
                }
        }
        .onAppear{
            startFunc()
        }
    }
    //日付表示のフォーマット
    //    private let itemFormatter: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.calendar = Calendar(identifier: .gregorian)
    //        formatter.locale = Locale(identifier: "en_US")
    //        formatter.dateStyle = .medium
    //        formatter.timeStyle = .none
    //        return formatter
    //    }()
}
