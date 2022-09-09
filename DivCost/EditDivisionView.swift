//
//  EditDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct EditDivisionView: View {
    
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
                    HStack {
                        TextField(division.name, text: $newDivisionName)
                        Spacer()
                        Button(action: {
                            division.name = newDivisionName
                            newDivisionName = ""
                        }) {
                            Image(systemName: "checkmark")
                        }
                        .disabled(newDivisionName.isEmpty)
                    }
                    Text("People:")
                        .font(.headline)
                    ForEach(division.people) { person in
                        Text(person.name)
                    }
                    .onDelete { indices in
                        division.people.remove(atOffsets: indices)
                    }
                    .padding(.leading)
                    HStack {
                        TextField("New person", text: $newPerson)
                        Spacer()
                        Button(action: {
                            division.people.append(Person(name: newPerson))
                            newPerson = ""
                        }) {
                            Image(systemName: "plus")
                        }
                        .disabled(newPerson.isEmpty)
                    }
                    .padding(.leading)
                    
                } header: {
                    Text("Details")
                }
                
                Section {
                    TextField("Product name", text: $newName)
                    HStack {
                        TextField("Product price", text: $newPrice)
                            .keyboardType(.numberPad)
                        Spacer()
                        Text("zł")
                    } //sprawdzic
                    HStack {
                        Text("Who paid:")
                            .font(.headline)
                        Spacer()
                        Picker("Who paid:", selection: $newBuyer) {
                            ForEach(division.people.sorted(by: Person.nameSort)) { person in
                                Text(person.name)
                                    .tag(person.name)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    HStack (alignment: .top) {
                        Text("For whom:")
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
                    .listRowBackground((newName.isEmpty || newPrice.isEmpty) ? Color.gray : Color.accentColor)
                } header: {
                    Text("New product")
                }
                
                Section {
                    ForEach(division.people.sorted()) { person in
                        //VStack (alignment: .leading){
//                            Text(person.name)
//                                .font(.headline)
//                            Spacer()
                            Section {
                                ForEach(person.expenses.sorted()) { expense in
                                    HStack {
                                        Text(expense.name)
                                        Spacer()
                                        Text("\(expense.price, specifier: "%.2f") zł")
                                    }
                                    .padding(.leading)
                                }
//                                .onDelete { indices in
//                                    person.expenses.remove(atOffsets: indices)
//                                }
                            } header: {
                                Text(person.name)
                                    .font(.headline)
                            }
                        }
                    //}
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

struct EditDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditDivisionView(division: .constant(Division.sampleDivisions[1]))
        }
        
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
