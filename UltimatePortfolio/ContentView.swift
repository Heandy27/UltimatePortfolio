//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Andy Heredia on 24/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var issues: [Issue] {
        let filter = dataController.selectedFilter ?? .all
        // Declara un array donde se guardarán los issues antes de devolverlos.
        var allIssues: [Issue]
        // Si el filtro está asociado a un tag específico (una etiqueta), se obtienen solo los issues relacionados con ese tag.
        if let tag = filter.tag {
            allIssues = tag.issues?.allObjects as? [Issue] ?? []
            /* Si no hay tag, se hace una consulta (fetchRequest) a Core Data.
             
             Se filtran los Issue cuya fecha de modificación (modifitacionDate) sea más reciente que una fecha mínima establecida en el filtro.*/
        } else {
            let request = Issue.fetchRequest()
            request.predicate = NSPredicate(format: "modifitacionDate > %@", filter.minModificationDate as NSDate)
            
            allIssues = (try? dataController.container.viewContext.fetch(request)) ?? []
        }
        // Finalmente, devuelve los issues ordenados.
        return allIssues.sorted()
    }
    
    
    var body: some View {
        List(selection: $dataController.selectedIssue) {
            ForEach(issues) {issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Issues")
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = issues[offset]
            dataController.delete(item)
        }
    }
}

#Preview {
    ContentView()
}
