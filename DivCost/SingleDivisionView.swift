//
//  SingleDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 06/09/2022.
//

import SwiftUI

struct SingleDivisionView: View {   //wylaczyc guzik cofania jak sheet sie pojawia - enviroment var na przyklad
    
    @Binding var division: Division
    
    @State private var data = Division.Data()
    
    @State private var editSheetShown = false
    
    @State private var bottomOffset = UIScreen.main.bounds.height
    @State private var topOffset = -UIScreen.main.bounds.height*0.5
    
    @Binding var backButtonShown: Bool
    
    let themeColor = Color.mint//Color("MainColor")
    let themeDarkerColor = Color(UIColor(Color.mint).darker().darker())
    let themeLighterColor = Color.mint.opacity(0.2)
    
    var namespace: Namespace.ID
    
    init(division: Binding<Division>, namespace: Namespace.ID, backButtonShown: Binding<Bool>) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._division = division
        self.namespace = namespace
        self._backButtonShown = backButtonShown
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(themeColor)
                    .ignoresSafeArea()
                //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.15, alignment: .center)
                //.shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                    .matchedGeometryEffect(id: "titleBG", in: namespace)
                
                Text(division.name)
                    .foregroundColor(.black)
                    .padding(.bottom,10)
                    .font(.system(size: 40).weight(.bold))
                    .offset(x: 0, y: topOffset)
                //.offset(x: 0, y: UIScreen.main.bounds.height*(0.02))
            }
            .fixedSize(horizontal: false, vertical: true)
            //.ignoresSafeArea()
            .matchedGeometryEffect(id: "title", in: namespace)
            
            Group {
                if editSheetShown {
                    ZStack {
                        AddExpensesView(data: $data, themeColor: themeColor, namespace: namespace)
                        
                        VStack {
                            Spacer()
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.red.opacity(0.5))
                                        .overlay {
                                            Circle()
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    Button(action: {
                                        withAnimation {
                                            editSheetShown = false
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.headline)
                                            .foregroundColor(.darkRed)
                                            .padding(20)
                                    }
                                }
                                .fixedSize()
                                .matchedGeometryEffect(id: "cancelProductButton", in: namespace)
                                Spacer()
                                withAnimation {
                                    ZStack {
                                        Circle()
                                            .fill(.black.opacity(0.4))
                                            .overlay {
                                                Circle()
                                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                            }
                                        Button(action: {
                                            division.update(from: data)
                                            division.people.sort(by: Person.nameSort)
                                            withAnimation {
                                                editSheetShown = false
                                            }
                                        }) {
                                            Image(systemName: "checkmark")
                                                .font(.headline)
                                                .foregroundColor(themeDarkerColor)
                                                .padding(20)
                                        }
                                    }
                                    .fixedSize()
                                    .matchedGeometryEffect(id: "confirmProductButton", in: namespace)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                    .onAppear {
                        withAnimation {
                            backButtonShown = false
                        }
                    }
                    .onDisappear {
                        withAnimation {
                            backButtonShown = true
                        }
                    }
                }
                
                else {
                    ZStack {
                        VStack {
                            
                            
                            VStack {
                                //                RoundedRectangle(cornerRadius: 30)
                                //                    .fill(themeLighterColor)
                                //                    .ignoresSafeArea()
                                //                    .shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                                //List {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(themeLighterColor)
                                        .matchedGeometryEffect(id: "topBG", in: namespace)
                                    //List {
                                    //Section {
                                    VStack(alignment: .leading){
                                        Text("Summary")
                                            .font(.footnote.bold())
                                            .foregroundColor(.black)
                                        //NavigationLink(destination: CalculationsView(calculations: division.countUp())) {
                                        ZStack (alignment: .leading){
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(themeColor)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            HStack {
                                                Label("Calculated Divisions", systemImage: "function")
                                                //.labelStyle(DualColorLabel(iconColor: .black))
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                            }
                                            //.padding(10)
                                            .padding(.horizontal)
                                        }
                                        //.scaledToFit()
                                        
                                        //}
                                        HStack {
                                            Label("Total", systemImage: "banknote")
                                                .labelStyle(DualColorLabel(iconColor: themeDarkerColor))
                                            Spacer()
                                            Text("\(division.total, specifier: "%.2f") zł")
                                        }
                                        .padding(.horizontal)
                                        .padding(.top,5)
                                    }
                                    .padding()
                                    
                                    
                                    
                                    //.listRowBackground(Color.clear)
                                    //.listRowSeparator(.hidden)
                                    
                                    //}
                                    //.listStyle(.plain)
                                    //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.2, alignment: .bottom)
                                }
                                .scaledToFit()
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(themeLighterColor)
                                        .matchedGeometryEffect(id: "bottomBG", in: namespace)
                                    VStack (alignment: .leading){
                                        VStack {
                                            Text("People & Expenses")
                                                .font(.footnote.bold())
                                                .foregroundColor(.black)
                                        }
                                        .padding([.leading, .top])
                                        List {
                                            ForEach(division.people.sorted()) { person in
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(.white)
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                        }
                                                    VStack {
                                                        HStack {
                                                            Label("\(person.name)", systemImage: "person")
                                                                .font(.headline)
                                                                .labelStyle(DualColorLabel(iconColor: themeDarkerColor))
                                                            Spacer()
                                                            Text("\(person.balance, specifier: "%.2f") zł")
                                                                .font(.footnote.bold())
                                                                .foregroundColor(getBalanceColor(balance: person.balance))
                                                        }
                                                        Group {
                                                            if hasExpenses(expenses: person.expenses) {
                                                                ZStack {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .fill(Color.green.opacity(0.2))
                                                                    VStack {
                                                                        ForEach(person.expenses.sorted()) { expense in //
                                                                            HStack {
                                                                                Label("\(expense.name)", systemImage: "chevron.up")
                                                                                Spacer()
                                                                                Text("\(expense.price, specifier: "%.2f") zł") //można potem dodać wybieranie waluty i guess
                                                                            }
                                                                            .padding(.vertical,2)
                                                                            .foregroundColor(Color.darkGreen)
                                                                            //.listRowSeparator(.hidden)
                                                                            //.listRowBackground(Color.green.opacity(0.2))
                                                                        }
                                                                    }
                                                                    .padding()
                                                                }
                                                                .fixedSize(horizontal: false, vertical: true)
                                                            } else {}
                                                        }
                                                        Group {
                                                            if hasDebts(debts: person.debts) {
                                                                ZStack {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .fill(Color.red.opacity(0.2))
                                                                    VStack {
                                                                        ForEach(person.debts.sorted()) { debt in //
                                                                            HStack {
                                                                                Label("\(debt.name)", systemImage: "chevron.down")
                                                                                Spacer()
                                                                                Text("\(debt.price, specifier: "%.2f") zł")
                                                                            }
                                                                            .padding(.vertical,2)
                                                                            .foregroundColor(Color.darkRed)
                                                                            //.listRowSeparator(.hidden)
                                                                            //.listRowBackground(Color.red.opacity(0.2))
                                                                        }
                                                                    }
                                                                    .padding()
                                                                }
                                                                .fixedSize(horizontal: false, vertical: true)
                                                            } else {}
                                                        }
                                                    }
                                                    .padding()
                                                }
                                                .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                            }
                                            .listRowBackground(Color.clear)
                                            .listRowSeparator(.hidden)
                                            Spacer(minLength: 100)
                                                .listRowBackground(Color.clear)
                                                .listRowSeparator(.hidden)
                                        }
                                        //                    } header: {
                                        //                        Text("People")
                                        //                    }
                                        
                                        .listStyle(.plain)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        
                                    }
                                    //.padding()
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .offset(x: 0, y: bottomOffset)
                                //}
                                //.listStyle(.plain)
                                //.padding([.leading,.trailing])
                            }
                            .ignoresSafeArea()
                            //.padding()
                        }
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(themeColor)
                                        .overlay {
                                            Circle()
                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                        }
                                    Button(action: {
                                        withAnimation {
                                            data = division.data
                                            editSheetShown = true
                                        }
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .padding(20)
                                    }
                                }
                                .fixedSize()
                                .matchedGeometryEffect(id: "editProductCard", in: namespace)
                                .matchedGeometryEffect(id: "cancelProductButton", in: namespace)
                                .matchedGeometryEffect(id: "confirmProductButton", in: namespace)
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                    .onAppear {
                        withAnimation {
                            bottomOffset = 0
                        }
                    }
                    .onDisappear {
                        withAnimation {
                            bottomOffset = UIScreen.main.bounds.height
                        }
                    }
                }
                
            }
        }
        .onAppear {
            withAnimation {
                topOffset = 0
            }
        }
        .onDisappear {
            withAnimation {
                topOffset = -UIScreen.main.bounds.height*0.5
            }
        }
        //        .navigationTitle(division.name)
        //        .toolbar {
        //            ToolbarItem(placement: .navigationBarTrailing) {
        //                Button("Edit") {
        //                    data = division.data
        //                    editSheetShown = true
        //                }
        //            }
        //        }
        //        .sheet(isPresented: $editSheetShown) {
        //            NavigationView {
        //                AddExpensesView(data: $data)
        //                    .toolbar {
        //                        ToolbarItem(placement: .cancellationAction) {
        //                            Button("Cancel") {
        //                                editSheetShown = false
        //                            }
        //                            .foregroundColor(.red)
        //                        }
        //                        ToolbarItem(placement: .confirmationAction) {
        //                            Button("Update") {
        //                                division.update(from: data)
        //                                division.people.sort(by: Person.nameSort)
        //                                editSheetShown = false
        //                            }
        //                        }
        //                }
        //            }
        //        }
    }
}

struct SingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDivisionView(division: .constant(Division.sampleDivisions[1]), namespace: Namespace.init().wrappedValue, backButtonShown: .constant(false))
    }
}

extension SingleDivisionView {
    func getBalanceColor(balance: Double) -> Color {
        if balance == 0 {
            return .gray
        } else if balance > 0 {
            return .green
        } else {
            return .red
        }
    }
    
    func hasExpenses(expenses: [Product]) -> Bool {
        if expenses.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func hasDebts(debts: [Product]) -> Bool {
        if debts.count > 0 {
            return true
        } else {
            return false
        }
    }
}

extension Color {
    static let darkGreen = Color(red: 100/255, green: 160/255, blue: 100/255)
    static let darkRed = Color(red: 160/255, green: 100/255, blue: 100/255)
}
