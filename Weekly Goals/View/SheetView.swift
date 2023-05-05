//
//  SheetView.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/05.
//データ入力画面
//

import Foundation
import SwiftUI

struct SheetView: View {
    @ObservedObject var model : Model
    @Environment(\.managedObjectContext)private var context
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .leading){
                //キャンセルボタンと保存ボタン
                HStack {
                    //キャンセルの場合は保存せず閉じる
                    Button("Cansel", action:{
                        model.isNewData = false
                    }).foregroundColor(.white)
                    Spacer()
                    //保存の場合はモデルでデータ処理
                    Button("Save", action:
                            {
                        model.writeData(context: context)
                    }
                    ).foregroundColor(.white)
                }
                .padding(.bottom, 20.0)
                //文字の入力
                TextField("Title", text: $model.title).textFieldStyle(RoundedBorderTextFieldStyle())
                Picker(selection: $model.goal, label: Text("目標日数")) {
                    Text("1").tag(1).foregroundColor(Color.white)
                    Text("2").tag(2).foregroundColor(Color.white)
                    Text("3").tag(3).foregroundColor(Color.white)
                    Text("4").tag(4).foregroundColor(Color.white)
                    Text("5").tag(5).foregroundColor(Color.white)
                    Text("6").tag(6).foregroundColor(Color.white)
                    Text("7").tag(7).foregroundColor(Color.white)
                }
                .pickerStyle(WheelPickerStyle())
                Spacer()
            }.padding()
        }
    }
}

//プレビュー用コード
struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(model: Model()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
