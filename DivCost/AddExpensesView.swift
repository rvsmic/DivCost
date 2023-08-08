//
//  AddExpensesView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct AddExpensesView: View {
    @Binding var data: Division.Data
    
    @Binding private var newName: String
    @Binding private var newPrice: String
    @Binding private var newBuyer: String
    @Binding private var deletedExpense: Bool
    
    @State private var showNumberError: Bool = false
    @State private var editDetailsShown: Bool = false
    
    @Binding private var customDivision: Bool
    @Binding private var customAmount: [UUID:String]
    
    @State private var allChecked: Bool = false
    
    init(data: Binding<Division.Data>, newName: Binding<String>, newPrice: Binding<String>, newBuyer: Binding<String>, deletedExpense: Binding<Bool>, customDivision: Binding<Bool>, customAmount: Binding<[UUID:String]>) {
        self._data = data
        self._newName = newName
        self._newPrice = newPrice
        self._newBuyer = newBuyer
        self._deletedExpense = deletedExpense
        self._customDivision = customDivision
        self._customAmount = customAmount
    }
    
    var body: some View {
        List {
            Group {
                if deletedExpense {
                    VStack {
                        Spacer(minLength: 100)
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(UIColor.systemBackground))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.red.opacity(0.2))
                                }
                            VStack {
                                Text("Delete Expenses Mode")
                                    .font(.title).bold()
                                    .foregroundColor(Color.darkRed)
                                Text("Click Update or Discard to Exit")
                            }
                            .padding(20)
                        }
                        Spacer(minLength: 100)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    Section ("Expense Name") {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(UIColor.systemBackground))
                            TextField("Expense Name", text: $newName)
                                .padding(15)
                                .padding(.horizontal)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical,-5)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    Group {
                        if customDivision {
                            
                        } else {
                            Section ("How Much") {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(UIColor.systemBackground))
                                    HStack {
                                        TextField("Price", text: $newPrice)
                                            .numbersOnly($newPrice)
                                        Spacer()
                                        Text("zł")
                                    }
                                    .padding(15)
                                    .padding(.horizontal)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical,-5)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                        Section ("Who Paid") {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(UIColor.systemBackground))
                                Picker("Who Paid:", selection: $newBuyer) {
                                    ForEach(data.people.sorted(by: Person.nameSort)) { person in
                                        Text(person.name)
                                            .tag(person.name)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding(10)
                                .padding(.horizontal)
                                .labelsHidden()
                                .pickerStyle(.menu)
                                .accentColor(data.theme.textColor)
                            }
                            .padding(.vertical,-5)
                            .fixedSize(horizontal: false, vertical: true)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        Section ("For Whom") {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(UIColor.systemBackground))
                                ScrollView (.horizontal){
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(data.theme.mainColor.opacity(0.5))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .stroke(Material.ultraThin, lineWidth: 10)
                                                }
                                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                                .opacity(allChecked ? 1 : 0)
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Material.thin)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .stroke(data.theme.mainColor.opacity(0.2), lineWidth: 10)
                                                }
                                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                                .opacity(allChecked ? 0 : 1)
                                            Text("All")
                                                .padding(10)
                                                .padding(.horizontal, 10)
                                                .foregroundColor(data.theme.textColor)
                                                .opacity(allChecked ? 1 : 0)
                                            Text("All")
                                                .padding(10)
                                                .padding(.horizontal, 10)
                                                .foregroundColor(.primary)
                                                .opacity(allChecked ? 0 : 1)
                                            
                                        }
                                        .font(.headline)
                                        .fixedSize()
                                        .animation(Animation.easeInOut, value: 0.5)
                                        .onTapGesture {
                                            allChecked.toggle()
                                            if allChecked {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    data.checkAll()
                                                }
                                            } else {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    data.unCheckAll()
                                                    customAmount = Dictionary(uniqueKeysWithValues: customAmount.map { ($0.key, "") })
                                                }
                                            }
                                        }
                                        ForEach($data.people.sorted {$0.name.wrappedValue.lowercased() < $1.name.wrappedValue.lowercased()}) { $person in
                                            CheckBoxView(text: person.name, checked: $person.checked, color: data.theme.mainColor, textColor: data.theme.textColor, allChecked: $allChecked, divisionData: $data, personID: person.id, customAmount: $customAmount)
                                                .padding(1)
                                        }
                                    }
                                    .padding(.vertical,5)
                                    .padding(.horizontal,10)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    Section("Custom Division") {
                        Button(action: {
                            withAnimation {
                                customDivision.toggle()
                                for (key,_) in customAmount {
                                    customAmount[key] = ""
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    newPrice = ""
                                }
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(data.theme.mainColor)
                                Image(systemName: customDivision ? "xmark" : "chevron.right")
                                    .foregroundColor(data.theme.textColor)
                                    .font(.headline)
                                    .padding(.vertical,15)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        Group {
                            if customDivision && !data.people.filter({ person in person.checked == true }).isEmpty {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(UIColor.systemBackground))
                                    VStack {
                                        ForEach(data.people.filter( {$0.checked} ).sorted(by: Person.nameSort)) { person in
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(.ultraThinMaterial)
                                                HStack {
                                                    Text(person.name)
                                                    Spacer()
                                                    TextField("Amount", text: binding(person))
                                                        .multilineTextAlignment(.trailing)
                                                        .numbersOnly(binding(person))
                                                    Spacer()
                                                    Text("zł")
                                                }
                                                .padding(.vertical,15)
                                                .padding(.horizontal,20)
                                            }
                                            .padding(.top,5)
                                            .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .padding()
                                    .padding(.top,-5)
                                    .padding(.vertical,-5)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            } else {
                                if customDivision {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color(UIColor.systemBackground))
                                        Text("No debtors selected...")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(.vertical,10)
                                            .padding(.horizontal,20)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                } else {
                                    
                                }
                            }
                        }
                    }
                }
            }
            Section ("All Expenses") {
                ForEach(data.people.sorted(by: Person.nameSort)) { person in
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        Text(person.name)
                            .padding(15)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical,-5)
                    ForEach(person.expenses.sorted()) { expense in
                        HStack {
                            Image(systemName: "chevron.right")
                                .padding(.leading)
                                .font(.title2.bold())
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(UIColor.systemBackground))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(.ultraThinMaterial)
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(data.theme.mainColor.opacity(0.2))
                                    }
                                Text(expense.name)
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Group {
                                if deletedExpense {
                                    
                                } else {
                                    Button {
                                        newName = expense.name
                                        newPrice = String(expense.price)
                                        newBuyer = person.name
                                        data.updateChecks(expenseName: expense.name)
                                        withAnimation {
                                            data.removeProduct(productName: expense.name)
                                        }
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                            .font(.headline)
                                            .foregroundColor(data.theme.textColor)
                                    }
                                    .tint(data.theme.mainColor)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    data.removeProduct(productName: expense.name)
                                    deletedExpense = true
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Spacer(minLength: 200)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .background(data.theme.mainColor.opacity(0.1))
        .background(.ultraThinMaterial)
        .listStyle(.plain)
        .scrollDismissesKeyboard(.interactively)
        .interactiveDismissDisabled()
    }
    
    
    private func binding(_ person: Person) -> Binding<String> {
        Binding<String>(
            get: { customAmount[person.id] ?? "" },
            set: { customAmount[person.id] = $0 }
        )
    }
}


struct AddExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddExpensesView(data: .constant(Division.sampleDivisions[1].data), newName: .constant("Club"), newPrice: .constant("23.50"), newBuyer: .constant("Daniel"), deletedExpense: .constant(false), customDivision: .constant(true), customAmount: .constant([UUID():"AAAA"]))
        }
    }
}
