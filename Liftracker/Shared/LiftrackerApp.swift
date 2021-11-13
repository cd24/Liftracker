//
//  LiftrackerApp.swift
//  Shared
//
//  Created by John McAvey on 11/13/21.
//

import SwiftUI

@main
struct LiftrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
