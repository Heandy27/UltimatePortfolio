//
//  DetailView.swift
//  UltimatePortfolio
//
//  Created by Andy Heredia on 25/4/25.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        VStack {
            if let issue = dataController.selectedIssue {
                IssueView(issue: issue)
            } else {
                NoIssueView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView()
}
