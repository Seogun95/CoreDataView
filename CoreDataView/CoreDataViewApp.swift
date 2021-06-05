//
//  CoreDataViewApp.swift
//  CoreDataView
//
//  Created by Seogun Kim on 2021/06/05.
//

import SwiftUI

@main
struct CoreDataViewApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
 
