//
//  AddExpensesView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct AddExpensesView: View {
    
    @Binding var division: Division
    
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    
    @State private var newName: String = ""
    @State private var newPrice: String = ""
    @State private var newBuyer: String = ""
    
    @State private var showNumberError: Bool = false
    
    init(division: Binding<Division>) {
        self._division = division//.people.sorted(by: { $person1, $person2 in return person1.name > person2.name } )
    }
    
    var body: some View {
        //Form {
            List {
                Section {
                    NavigationLink(destination: EditSingleDivisionView(division: $division)) {
                        Text("Edit division details")
                    }
                } header: {
                    Text("General")
                }
                
                Section {
                    TextField("Product Name", text: $newName)
                    HStack {
                        TextField("Product Price", text: $newPrice)
                            .keyboardType(.numberPad)
                        Spacer()
                        Text("zł")
                    } //sprawdzic
                    HStack {
                        Text("Who Paid:")
                            .font(.headline)
                        Spacer()
                        Picker("Who Paid:", selection: $newBuyer) {
                            ForEach(division.people.sorted(by: Person.nameSort)) { person in
                                Text(person.name)
                                    .tag(person.name)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    HStack (alignment: .top) {
                        Text("For Whom:")
                            .font(.headline)
                        Spacer()
                        VStack (alignment: .leading) {
                            ForEach($division.people) { $person in
                                CheckBoxView(text: person.name, checked: $person.checked)
                                    .padding(1)
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            var debtorsId: [UUID] = []
                            var buyerId: UUID = UUID()
                            
                            for person in division.people {
                                if person.checked {
                                    debtorsId.append(person.id)
                                }
                                if person.name == newBuyer {
                                    buyerId = person.id
                                }
                            }
                            
                            if let doubleNewPrice = newPrice.toDouble() {
                                withAnimation {
                                    division.addProduct(newName: newName, newPrice: doubleNewPrice, buyerId: buyerId, debtorsId: debtorsId)
                                }
                            } else {
                                showNumberError = true //cos wyswietlić
                            }
                            newName = ""
                            newPrice = ""
                            newBuyer = division.people.sorted(by: Person.nameSort)[0].name
                            for i in 0..<division.people.count {
                                division.people[i].checkReset()
                            }
                            
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.headline.weight(.heavy))
                        }
                        .disabled(newName.isEmpty || newPrice.isEmpty)
                        Spacer()
                    }
                    .listRowBackground((newName.isEmpty || newPrice.isEmpty) ? Color.black.opacity(0.2) : Color.accentColor)
                } header: {
                    Text("New Product")
                }
                
                Section {
                    ForEach($division.people) { $person in //.sorted()
                        Section {
                            ForEach(person.expenses.sorted()) { expense in
                                HStack {
                                    Text(expense.name)
                                    Spacer()
                                    Text("\(expense.price, specifier: "%.2f") zł")
                                }
                                .padding(.leading)
                            }
//                            .onDelete { indices in
//                                person.expenses.remove(atOffsets: indices)  //trzeba skasować również innym + to nie dziala o dziwos
//                            }
                        } header: {
                            Text(person.name)
                                .font(.headline)
                        }
                    }
                } header: {
                    Text("Expenses")
                }
            }
            .onAppear {
                if !division.people.isEmpty {
                    newBuyer = division.people.sorted(by: Person.nameSort)[0].name
                }
                newDivisionName = division.name
                for i in 0..<division.people.count {
                    division.people[i].checkReset()
                }
            }
            .sheet(isPresented: $showNumberError) { //moze zmienic na popup tylko
                NavigationView {
                    VStack {
                        Text("Number error in added product!")
                            .foregroundColor(Color.red)
                            .font(.headline)
                        Text("Try again.")
                            .font(.caption)
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Dismiss") {
                                showNumberError = false
                            }
                        }
                    }
                }
            }
            
            //.listStyle(.plain)
            //.padding([.leading,.trailing])
            .navigationTitle("\(division.name)")
            .navigationBarTitleDisplayMode(.inline)
        //}
    }
}

struct AddExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddExpensesView(division: .constant(Division.sampleDivisions[1]))
        }
        
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
