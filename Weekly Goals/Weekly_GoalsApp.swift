//
//  Weekly_GoalsApp.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/04.
//

import SwiftUI

@main
struct Weekly_GoalsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
