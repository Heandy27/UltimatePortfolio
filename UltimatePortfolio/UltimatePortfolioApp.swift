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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
