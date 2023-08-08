//
//  SingleDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct SingleDivisionView: View {
    
    @Binding var division: Division
    
    @State private var data = Division.Data()
    
    @State private var addSheetShown = false
    @State private var calculationsSheetShown = false
    @State private var editDetailsSheetShown = false
    
    @State private var newName: String = ""
    @State private var newPrice: String = ""
    @State private var newBuyer: String = ""
    @State private var deletedExpense: Bool = false
    
    @State private var customDivision: Bool = false
    @State private var customAmount: [UUID:String] = [:]
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    init(division: Binding<Division>, saveAction: @escaping ()->Void) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._division = division
        self.saveAction = saveAction
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 20)
                List {
                    Section ("Summary") {
                        VStack {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(division.theme.mainColor.opacity(0.7))
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(.ultraThinMaterial)
                                    Label(division.getStringDate(), systemImage: "calendar")
                                        .labelStyle(SmallDistanceLabel())
                                        .padding(10)
                                }
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(division.theme.mainColor.opacity(0.7))
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(.ultraThinMaterial)
                                    Label("\(division.total, specifier: "%.2f") zł", systemImage: "banknote")
                                        .labelStyle(SmallDistanceLabel())
                                        .padding(10)
                                }
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(division.theme.mainColor.opacity(0.7))
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.ultraThinMaterial)
                                
                                HStack {
                                    Spacer()
                                    Label("Edit Details",systemImage: "gear")
                                        .labelStyle(SmallDistanceLabel())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding(10)
                            }
                            .onTapGesture {
                                data = division.data
                                editDetailsSheetShown = true
                            }
                        }
                        .foregroundColor(division.theme.textColor)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.top,20)
                    }
                    Section (header:
                                HStack{
                        Text("People & Expenses")
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(UIColor.systemBackground))
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.green.opacity(0.2))
                                    Text("Paid")
                                        .padding(5)
                                        .foregroundColor(Color.darkGreen)
                                }
                                .fixedSize()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.red.opacity(0.2))
                                    Text("Owed")
                                        .padding(5)
                                        .foregroundColor(Color.darkRed)
                                }
                                .fixedSize()
                            }
                            .padding(5)
                        }
                        .fixedSize()
                        .font(.caption).bold()
                        
                    }){
                        ForEach(division.people.sorted()) { person in
                            PersonExpensesView(person: person, theme: division.theme)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.top,20)
                        }
                    }
                    Spacer(minLength: 200)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .background(division.theme.mainColor.opacity(0.1))
                .background(.ultraThinMaterial)
            }
            .navigationTitle(division.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        data = division.data
                        addSheetShown = true
                        newBuyer = division.people[0].name
                        customAmount = Dictionary(uniqueKeysWithValues: zip(data.people.map{ $0.id },Array(repeating: "", count: data.people.count)))
                    }) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.system(size: 20)).bold()
                        }
                    }
                }
            }
            .sheet(isPresented: $addSheetShown) {
                NavigationView {
                    AddExpensesView(data: $data, newName: $newName, newPrice: $newPrice, newBuyer: $newBuyer, deletedExpense: $deletedExpense, customDivision: $customDivision, customAmount: $customAmount)
                        .navigationTitle("Add Expense")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Discard") {
                                    deletedExpense = false
                                    addSheetShown = false
                                    //delay zeby ui nie migalo przy zamykaniu sheeta
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        newName = ""
                                        newPrice = ""
                                        newBuyer = division.people[0].name
                                        customDivision = false
                                        customAmount = [:]
                                    }
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Group {
                                    if deletedExpense {
                                        Button("Update") {
                                            deletedExpense = false
                                            addSheetShown = false
                                            data.checkReset()
                                            division.update(from: data)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                newName = ""
                                                newPrice = ""
                                                newBuyer = division.people[0].name
                                                customDivision = false
                                                customAmount = [:]
                                            }
                                        }
                                    } else {
                                        Button("Add") {
                                            addSheetShown = false
                                            var debtorsId: [UUID] = []
                                            var buyerId: UUID = UUID()
                                            
                                            for person in data.people {
                                                if person.checked {
                                                    debtorsId.append(person.id)
                                                }
                                                if person.name == newBuyer {
                                                    buyerId = person.id
                                                }
                                            }
                                            if customDivision {
                                                data.addCustomProduct(newName: newName, customAmount: customAmount, buyerId: buyerId, debtorsId: debtorsId)
                                            } else {
                                                data.addProduct(newName: newName, newPrice: newPrice.toDouble()!, buyerId: buyerId, debtorsId: debtorsId)
                                            }
                                            data.checkReset()
                                            division.update(from: data)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                newName = ""
                                                newPrice = ""
                                                newBuyer = division.people[0].name
                                                customDivision = false
                                                customAmount = [:]
                                            }
                                        }
                                        .disabled(
                                            newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                            (newPrice.isEmpty && !customDivision) ||
                                            // jezeli ktoras z checked osob nie ma wpisanej kwoty lub ma 0
                                            (customAmount.filter { data.people.filter { $0.checked }.map { $0.id }.contains($0.key) }.contains { $0.value.isEmpty || (Double($0.value) ?? 0.0) == 0.0 } && customDivision) ||
                                            newBuyer.isEmpty ||
                                            data.people.filter { person in person.checked == true }.count == 0
                                    )
                                    }
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $editDetailsSheetShown) {
                NavigationView {
                    EditSingleDivisionView(data: $data)
                        .navigationTitle("Edit \(division.name)")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Discard") {
                                    editDetailsSheetShown = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Update") {
                                    data.whitespacesNamesFix()
                                    division.update(from: data)
                                    editDetailsSheetShown = false
                                }
                                .disabled(
                                    data.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                    data.anyNamesEmpty()
                                )
                            }
                        }
                }
            }
            .tint(.primary)
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(division.theme.mainColor)
                    NavigationLink(destination: CalculationsView(calculations: division.countUp(), theme: division.theme)) {
                        HStack {
                            Label("Calculated Divisions", systemImage: "function")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(division.theme.textColor)
                        .font(.headline)
                        .padding(.vertical, 20)
                        .padding(.horizontal)
                    }
                }
                .fixedSize()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct SingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SingleDivisionView(division: .constant(Division.sampleDivisions[1]), saveAction: {})
        }
    }
}
