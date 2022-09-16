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
    
    let themeColor: Color
    let themeDarkerColor: Color
    let themeLighterColor: Color
    
    var namespace: Namespace.ID
    
    init(data: Binding<Division.Data>, themeColor: Color, namespace: Namespace.ID) {
        self._data = data
        self.themeColor = themeColor
        self.themeDarkerColor = Color(UIColor(themeColor).darker().darker())
        self.themeLighterColor = themeColor.opacity(0.2)
        self.namespace = namespace
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(themeColor)
                        
                        List {
                            Section {
                                Text("General")
                                    .foregroundColor(.black)
                                    .font(.footnote.bold())
                                Button(action: {}) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(themeDarkerColor)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                            }
                                        HStack {
                                            Text("Edit Division Details")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }//NavigationLink(destination: EditSingleDivisionView(data: $data)) {
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                    }
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            
                            Section {
                                Text("New Product")
                                    .font(.footnote.bold())
                                    .foregroundColor(.black)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    TextField("Product Name", text: $newName)
                                        .padding()
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
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
                                        .fill(.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    HStack {
                                        Text("Who Paid:")
                                            .font(.headline)
                                        Spacer()
                                        Picker("Who Paid:", selection: $newBuyer) {
                                            ForEach(data.people.sorted(by: Person.nameSort)) { person in
                                                Text(person.name)
                                                    .tag(person.name)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        .accentColor(themeDarkerColor)
                                    }
                                    .padding()
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    HStack (alignment: .top) {
                                        Text("For Whom:")
                                            .font(.headline)
                                        Spacer()
                                        VStack (alignment: .leading) {
                                            ForEach($data.people) { $person in
                                                CheckBoxView(text: person.name, checked: $person.checked, color: themeDarkerColor)
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
                                            showNumberError = true
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
                                                .fill(Color.black.opacity(0.4))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            Image(systemName: "plus")
                                                .foregroundColor(themeColor)
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
                                    .foregroundColor(.black)
                                ForEach($data.people) { $person in //.sorted()
                                    Section {
                                        ZStack (alignment: .leading){
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.white)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            Label(person.name, systemImage: "person")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                .padding()
                                        }
                                        ForEach(person.expenses.sorted()) { expense in
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.white)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(themeLighterColor)
                                                    }
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
                                            }
                                            .padding(.leading)
                                        }
                                        //                            .onDelete { indices in
                                        //                                person.expenses.remove(atOffsets: indices)  //trzeba skasować również innym + to nie dziala o dziwos
                                        //                            }
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
                }
                .padding(.horizontal)
                RoundedRectangle(cornerRadius: 30)
                    .stroke(themeColor, lineWidth: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    //.padding(.horizontal)
                    .matchedGeometryEffect(id: "editProductCard", in: namespace)
                
                Group {
                    if showNumberError {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Material.ultraThin)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
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
                                    Button (action: {
                                        showNumberError = false
                                    }) {
                                        Label("Try Again", systemImage: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
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
        //Form {
        //            List {
        //                Section {
        //                    NavigationLink(destination: EditSingleDivisionView(data: $data)) {
        //                        Text("Edit division details")
        //                    }
        //                } header: {
        //                    Text("General")
        //                }
        //
        //                Section {
        //                    TextField("Product Name", text: $newName)
        //                    HStack {
        //                        TextField("Product Price", text: $newPrice)
        //                            .keyboardType(.numberPad)
        //                        Spacer()
        //                        Text("zł")
        //                    } //sprawdzic
        //                    HStack {
        //                        Text("Who Paid:")
        //                            .font(.headline)
        //                        Spacer()
        //                        Picker("Who Paid:", selection: $newBuyer) {
        //                            ForEach(data.people.sorted(by: Person.nameSort)) { person in
        //                                Text(person.name)
        //                                    .tag(person.name)
        //                            }
        //                        }
        //                        .pickerStyle(.menu)
        //                    }
        //
        //                    HStack (alignment: .top) {
        //                        Text("For Whom:")
        //                            .font(.headline)
        //                        Spacer()
        //                        VStack (alignment: .leading) {
        //                            ForEach($data.people) { $person in
        //                                CheckBoxView(text: person.name, checked: $person.checked)
        //                                    .padding(1)
        //                            }
        //                        }
        //                    }
        //
        //                    HStack {
        //                        Spacer()
        //                        Button(action: {
        //                            var debtorsId: [UUID] = []
        //                            var buyerId: UUID = UUID()
        //
        //                            for person in data.people {
        //                                if person.checked {
        //                                    debtorsId.append(person.id)
        //                                }
        //                                if person.name == newBuyer {
        //                                    buyerId = person.id
        //                                }
        //                            }
        //
        //                            if let doubleNewPrice = newPrice.toDouble() {
        //                                withAnimation {
        //                                    data.addProduct(newName: newName, newPrice: doubleNewPrice, buyerId: buyerId, debtorsId: debtorsId)
        //                                }
        //                            } else {
        //                                showNumberError = true
        //                            }
        //                            newName = ""
        //                            newPrice = ""
        //                            newBuyer = data.people.sorted(by: Person.nameSort)[0].name
        //                            for i in 0..<data.people.count {
        //                                data.people[i].checkReset()
        //                            }
        //
        //                        }) {
        //                            Image(systemName: "plus")
        //                                .foregroundColor(.white)
        //                                .font(.headline.weight(.heavy))
        //                        }
        //                        .disabled(newName.isEmpty || newPrice.isEmpty)
        //                        Spacer()
        //                    }
        //                    .listRowBackground((newName.isEmpty || newPrice.isEmpty) ? Color.black.opacity(0.2) : Color.accentColor)
        //                } header: {
        //                    Text("New Product")
        //                }
        //
        //                Section {
        //                    ForEach($data.people) { $person in //.sorted()
        //                        Section {
        //                            ForEach(person.expenses.sorted()) { expense in
        //                                HStack {
        //                                    Text(expense.name)
        //                                    Spacer()
        //                                    Text("\(expense.price, specifier: "%.2f") zł")
        //                                }
        //                                .padding(.leading)
        //                            }
        ////                            .onDelete { indices in
        ////                                person.expenses.remove(atOffsets: indices)  //trzeba skasować również innym + to nie dziala o dziwos
        ////                            }
        //                        } header: {
        //                            Text(person.name)
        //                                .font(.headline)
        //                        }
        //                    }
        //                } header: {
        //                    Text("Expenses")
        //                }
        //            }
        //            .onAppear {
        //                if !data.people.isEmpty {
        //                    newBuyer = data.people.sorted(by: Person.nameSort)[0].name
        //                }
        //                newDivisionName = data.name
        //                for i in 0..<data.people.count {
        //                    data.people[i].checkReset()
        //                }
        //            }
        //            .sheet(isPresented: $showNumberError) { //moze zmienic na popup tylko
        //                NavigationView {
        //                    VStack {
        //                        Text("Number error in added product!")
        //                            .foregroundColor(Color.red)
        //                            .font(.headline)
        //                        Text("Try again.")
        //                            .font(.caption)
        //                    }
        //                    .toolbar {
        //                        ToolbarItem(placement: .confirmationAction) {
        //                            Button("Dismiss") {
        //                                showNumberError = false
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //}
    }
}

struct AddExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpensesView(data: .constant(Division.sampleDivisions[1].data), themeColor: .mint, namespace: Namespace.init().wrappedValue)
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
