//
//  DivCostApp.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

@main
struct DivCostApp: App {
    
    @State var divisions: [Division] = Division.sampleDivisions
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                DivisionsView(divisions: $divisions)
            }
        }
    }
}
