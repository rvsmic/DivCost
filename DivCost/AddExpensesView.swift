//
//  AddExpensesView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct AddExpensesView: View {
    
    @Binding var data: Division.Data
    
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    
    @State private var newName: String = ""
    @State private var newPrice: String = ""
    @State private var newBuyer: String = ""
    
    @State private var showNumberError: Bool = false
    @State private var editDetailsShown: Bool = false
    
    var namespace: Namespace.ID
    
    init(data: Binding<Division.Data>, namespace: Namespace.ID) {
        self._data = data
        self.namespace = namespace
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                VStack {
                    Spacer()
                    //Group {
                        
                     //   else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(data.theme.mainColor)
                                
                                List {
                                    Section {
                                        Text("New Product")
                                            .font(.footnote.bold())
                                            .foregroundColor(data.theme.textColor)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(UIColor.systemBackground))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            TextField("Product Name", text: $newName)
                                                .padding()
                                        }
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(UIColor.systemBackground))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            HStack {
                                                TextField("Product Price", text: $newPrice)
                                                    .keyboardType(.numberPad)
                                                Spacer()
                                                Text("zł")
                                            }
                                            .padding()
                                        } //sprawdzic
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(UIColor.systemBackground))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            HStack {
                                                Text("Who Paid:")
                                                    .font(.headline)
                                                Spacer()
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(data.theme.mainColor)
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .fill(Material.thin)
                                                        }
                                                    Picker("Who Paid:", selection: $newBuyer) {
                                                        ForEach(data.people.sorted(by: Person.nameSort)) { person in
                                                            Text(person.name)
                                                                .tag(person.name)
                                                        }
                                                    }
                                                    .pickerStyle(.menu)
                                                    .padding(.horizontal)
                                                    .accentColor(data.theme.textColor)
                                                }
                                                .fixedSize()
                                            }
                                            .padding()
                                        }
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(UIColor.systemBackground))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            HStack (alignment: .top) {
                                                Text("For Whom:")
                                                    .font(.headline)
                                                Spacer()
                                                
                                                VStack (alignment: .trailing) {
                                                    ForEach($data.people) { $person in
                                                        CheckBoxView(text: person.name, checked: $person.checked, color: data.theme.mainColor, textColor: data.theme.textColor)
                                                            .padding(1)
                                                    }
                                                }
                                                
                                            }
                                            .padding()
                                        }
                                        
                                        HStack {
                                            Button(action: {
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
                                                
                                                if let doubleNewPrice = newPrice.toDouble() {
                                                    withAnimation {
                                                        data.addProduct(newName: newName, newPrice: doubleNewPrice, buyerId: buyerId, debtorsId: debtorsId)
                                                    }
                                                } else {
                                                    withAnimation {
                                                        showNumberError = true
                                                    }
                                                }
                                                newName = ""
                                                newPrice = ""
                                                newBuyer = data.people.sorted(by: Person.nameSort)[0].name
                                                for i in 0..<data.people.count {
                                                    data.people[i].checkReset()
                                                }
                                                
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Material.thin)
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                        }
                                                    Image(systemName: "plus")
                                                        .foregroundColor(.primary)
                                                        .font(.headline)
                                                        .padding()
                                                }
                                            }
                                            .opacity((newName.isEmpty || newPrice.isEmpty) ? 0 : 1)
                                            .disabled(newName.isEmpty || newPrice.isEmpty)
                                            
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    
                                    Section {
                                        Text("Expenses")
                                            .font(.footnote.bold())
                                            .foregroundColor(data.theme.textColor)
                                        ForEach(data.people.sorted()) { person in //.sorted()
                                            Section {
                                                ZStack (alignment: .leading){
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color(UIColor.systemBackground))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                        }
                                                    Label(person.name, systemImage: "person")
                                                        .labelStyle(DualColorLabel(iconColor: data.theme.mainColor))
                                                        .font(.headline)
                                                        .foregroundColor(.primary)
                                                        .padding()
                                                }
                                                ForEach(person.expenses.sorted()) { expense in
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Material.thin)
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                            }
                                                        HStack {
                                                            Text(expense.name)
                                                            Spacer()
                                                            Text("\(expense.price, specifier: "%.2f") zł")
                                                        }
                                                        .padding(.horizontal)
                                                        .padding(5)
                                                        .foregroundColor(data.theme.textColor)
                                                    }
                                                    .padding(.leading)
                                                }
                                                //                                        .onDelete { offsets in
                                                //                                            //person.expenses.remove(atOffsets: indices)  //trzeba skasować również innym + to nie dziala o dziwos
                                                ////                                            indices.sorted(by: >).forEach { (i) in
                                                ////                                                person.expenses.remove(at: i)
                                                ////                                            }
                                                //                                            //kurwa nw
                                                //                                        }
                                            }
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    
                                    Spacer(minLength: 100)
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                }
                                .listStyle(.plain)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                
                            }
                            .matchedGeometryEffect(id: "editProductCard", in: namespace)
                        //}
                    //}
                }
                .padding(.horizontal)
                RoundedRectangle(cornerRadius: 30)
                    .stroke(data.theme.mainColor, lineWidth: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .matchedGeometryEffect(id: "editProductCard", in: namespace)
                    .padding(.horizontal)
                
                Group {
                    if showNumberError {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Material.ultraThin)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2, alignment: .center)
                                .ignoresSafeArea()
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Material.regular)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.red, lineWidth: 3)
                                    }
                                VStack {
                                    Spacer()
                                    Text("Number error in added product!")
                                        .foregroundColor(Color.red)
                                        .font(.headline)
                                    Spacer()
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.red)
                                        Button (action: {
                                            showNumberError = false
                                        }) {
                                            Label("Try Again", systemImage: "chevron.right")
                                                .font(.caption.bold())
                                                .foregroundColor(.primary)
                                        }
                                        .padding()
                                    }
                                    .fixedSize()
                                    Spacer()
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.width*0.4, alignment: .center)
                        }
                        
                    } else {}
                }
            }
            
        }
        .onAppear {
            if !data.people.isEmpty {
                newBuyer = data.people.sorted(by: Person.nameSort)[0].name
            }
            newDivisionName = data.name
            for i in 0..<data.people.count {
                data.people[i].checkReset()
            }
        }
    }
}

struct AddExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpensesView(data: .constant(Division.sampleDivisions[1].data), namespace: Namespace.init().wrappedValue)
            .preferredColorScheme(.light)
        
        AddExpensesView(data: .constant(Division.sampleDivisions[1].data), namespace: Namespace.init().wrappedValue)
            .preferredColorScheme(.dark)
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
