//
//  ContentView.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var model = Model()
    @FetchRequest(
        //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        //        animation: .default)
        //    private var items: FetchedResults<Item>
        entity:Card.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \Card.date, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    var body: some View {
        VStack{
            //新規作成ボタン
            Button(action:
                    {model.isNewData.toggle()
            }){
                Text("New item").foregroundColor(Color.blue)
            }
            //タップするとシートが開く
            .sheet(isPresented: $model.isNewData,
                   content: {
                SheetView(model: model)
            })
            //データを表示する
            List{
                ForEach(cards){cards in
                    CardView(model: model, cards: cards)
                }
            }
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
