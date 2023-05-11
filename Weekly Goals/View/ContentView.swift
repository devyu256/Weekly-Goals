//
//  ContentView.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/04.
//

import SwiftUI
import CoreData
import GoogleMobileAds

struct AdmobBannerViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3228702018641843/2113275759"
        view.rootViewController = viewController
        view.load(GADRequest())
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var model = Model()
    @FetchRequest(
        //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        //        animation: .default)
        //    private var items: FetchedResults<Item>
        entity:Card.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \Card.serial, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>
    var body: some View {
        VStack{
            //新規作成ボタン
            Button(action:
                    {
                model.isNewData.toggle()
                model.serial = Int(cards.last?.serial ?? 0) + 1
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
                .onMove(perform: move)
            }
            .environment(\.editMode, .constant(.active))
        }
        AdmobBannerView()
        
    }
    private func move(from source: IndexSet, to destination: Int) {
            //下から上に並べ替え時の挙動
            if source.first! > destination {
                cards[source.first!].serial = cards[destination].serial - 1
                for i in destination...cards.count - 1 {
                    cards[i].serial = cards[i].serial + 1
                }
            }
            //上から下に並べ替え時の挙動
            if source.first! < destination {
                cards[source.first!].serial = cards[destination - 1].serial + 1
                for i in 0...destination - 1 {
                    cards[i].serial = cards[i].serial - 1
                }
            }
          saveData()
        }
        private func saveData() {
            try? self.viewContext.save()
        }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
