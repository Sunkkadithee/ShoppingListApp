//
//  IOS_ProjectApp.swift
//  IOS_Project
//
//  Created by Hamza Omar khan on 2025-03-12.
//

import SwiftUI

@main
struct IOS_ProjectApp: App {
    
    @StateObject private var dataController = DataController()

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
    }
}
