//
//  DivCostApp.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

@main
struct DivCostApp: App {
    
    @State private var divisions: [Division] = Division.sampleDivisions
    @StateObject private var divisionStore = DivisionStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            DivisionsView(divisions: $divisionStore.divisions) {
                DivisionStore.save(divisions: divisionStore.divisions) { result in
                    Task {
                        do {
                            try await DivisionStore.save(divisions: divisionStore.divisions)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Error saving divisions. Try again later.")
                        }
                    }
                }
            }
            .task {
                do {
                    divisionStore.divisions = try await DivisionStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Error loading divisions. Sample data will be loaded.")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                divisionStore.divisions = Division.sampleDivisions
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
    }
}
