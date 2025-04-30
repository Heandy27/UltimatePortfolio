//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Andy Heredia on 24/4/25.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView(sidebar: {
                SidebarView()
            }, content: {
                ContentView()
            }, detail: {
                DetailView()
            })
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) { oldValue, phase in
                if phase != .active {
                    dataController.save()
                }
            }
        }
    }
}
