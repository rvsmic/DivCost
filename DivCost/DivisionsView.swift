//
//  ContentView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct DivisionsView: View {
    
    @Binding var divisions: [Division]
    
    @State private var data = MultipleDivisions.MultipleData()
    
    @State private var showEditSheet = false
    @State private var showAddSheet = false
    
    @State private var newDivision: Division = Division.emptyDivision
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    let theme: Theme = .div_cost
    
    init(divisions: Binding<[Division]>, saveAction: @escaping ()->Void) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._divisions = divisions
        self.saveAction = saveAction
    }
    
    var body: some View {
        VStack {
            Text("DivCost")
                .font(.system(size: 70).weight(.heavy))
                .foregroundColor(.black)
                .offset(x: 0, y: -10)
            
            Spacer(minLength: 20)
            List {
                ForEach($divisions.sorted {($1.date.wrappedValue,$0.name.wrappedValue.lowercased()) < ($0.date.wrappedValue, $1.name.wrappedValue.lowercased())}) { $division in
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        NavigationLink(destination: SingleDivisionView(division: $division, saveAction: saveAction)) {
                            SingleDivisionCardView(division: division)
                        }
                        .padding(20)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical,-10)
                    .padding(.top,10)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                Spacer(minLength: 200)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .background(.ultraThinMaterial)
            .background(Color(UIColor.systemBackground))
        }
        .background(theme.mainColor)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    let multipleDivisions = MultipleDivisions(divisions: divisions)
                    data = multipleDivisions.multipleData
                    withAnimation {
                        showEditSheet = true
                    }
                }) {
                    VStack {
                        Image(systemName: "gear")
                            .font(.system(size: 20))
                    }
                }
                .tint(Color.black)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    withAnimation {
                        showAddSheet = true
                    }
                }) {
                    VStack {
                        Image(systemName: "plus")
                            .font(.system(size: 20)).bold()
                    }
                }
                .tint(Color.black)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationView {
                EditMultipleDivisionsView(data: $data)
                    .navigationTitle("Manage Divisions")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Discard") {
                                showEditSheet = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Update") {
                                var multipleDivisions = MultipleDivisions(divisions: divisions)
                                multipleDivisions.update(from: data)
                                divisions = multipleDivisions.unwrap()
                                showEditSheet = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            NavigationView {
                AddDivisionView(division: $newDivision)
                    .navigationTitle("Add New Division")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Discard") {
                                showAddSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    newDivision = Division.emptyDivision
                                }
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                divisions.append(Division(name: newDivision.name, people: newDivision.people, date: newDivision.date, theme: newDivision.theme))
                                showAddSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    newDivision = Division.emptyDivision
                                }
                            }
                            .disabled(
                                newDivision.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                newDivision.people.isEmpty ||
                                newDivision.anyNamesEmpty()
                            )
                        }
                    }
            }
        }
        .tint(.primary)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct DivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DivisionsView(divisions: .constant(Division.sampleDivisions), saveAction: {})
        }
    }
}
