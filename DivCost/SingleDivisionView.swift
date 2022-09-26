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
    
    @State private var editSheetShown = false
    @State private var calculationsSheetShown = false
    @State private var editDetailsSheetShown = false
    
    @State private var bottomOffset = UIScreen.main.bounds.height
    @State private var topOffset = -UIScreen.main.bounds.height*0.5
    
    @Binding var backButtonShown: Bool
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    var namespace: Namespace.ID
    
    @Environment(\.colorScheme) var colorScheme
    
    init(division: Binding<Division>, namespace: Namespace.ID, backButtonShown: Binding<Bool>, saveAction: @escaping ()->Void) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._division = division
        self.namespace = namespace
        self._backButtonShown = backButtonShown
        self.saveAction = saveAction
    }
    
    var body: some View {
        Group {
            if calculationsSheetShown {
                ZStack {
                    CalculationsView(calculations: division.countUp(), theme: division.theme, namespace: namespace)
                    
                    VStack {
                        Spacer()
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(UIColor.systemBackground).opacity(0.8))
                                    .overlay {
                                        Circle()
                                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                    }
                                Button(action: {
                                    withAnimation {
                                        calculationsSheetShown = false
                                    }
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(20)
                                }
                            }
                            .fixedSize()
                            Spacer()
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
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(division.theme.mainColor)
                            .ignoresSafeArea()
                        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.15, alignment: .center)
                        //.shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                            .matchedGeometryEffect(id: "titleBG", in: namespace)
                        
                        Text(division.name)
                            .foregroundColor(division.theme.textColor)
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
                                AddExpensesView(data: $data, namespace: namespace)
                                
                                VStack {
                                    Spacer()
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(.red.opacity(0.8))
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
                                                    .foregroundColor(.black)
                                                    .padding(20)
                                            }
                                        }
                                        .fixedSize()
                                        .matchedGeometryEffect(id: "cancelProductButton", in: namespace)
                                        Spacer()
                                        withAnimation {
                                            ZStack {
                                                Circle()
                                                    .fill(Color(UIColor.systemBackground).opacity(0.8))
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
                                                        .foregroundColor(.primary)
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
                        else if editDetailsSheetShown {
                            ZStack {
                                    EditSingleDivisionView(data: $data, namespace: namespace)
                                
                                VStack {
                                    Spacer()
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.red.opacity(0.8))
                                                .overlay {
                                                    Circle()
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            Button(action: {
                                                withAnimation {
                                                    editDetailsSheetShown = false
                                                }
                                            }) {
                                                Image(systemName: "xmark")
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                    .padding(20)
                                            }
                                        }
                                        .fixedSize()
                                        .matchedGeometryEffect(id: "editDivisionCancel", in: namespace)
                                        Spacer()
                                        ZStack {
                                            Circle()
                                                .fill(Color(UIColor.systemBackground).opacity(0.8))
                                                .overlay {
                                                    Circle()
                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                }
                                            Button(action: {
                                                withAnimation {
                                                    division.update(from: data)
                                                    editDetailsSheetShown = false
                                                }
                                            }) {
                                                Image(systemName: "checkmark")
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                    .padding(20)
                                            }
                                        }
                                        .fixedSize()
                                        .matchedGeometryEffect(id: "editDivisionConfirm", in: namespace)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
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
                            VStack {
                                Spacer()
                                ZStack {
                                    VStack {
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(Material.thin)
                                                    .matchedGeometryEffect(id: "topBG", in: namespace)
                                                
                                                VStack(alignment: .leading) {
                                                    Text("Summary")
                                                        .font(.footnote.bold())
                                                        .foregroundColor(.primary)
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .fill(division.theme.mainColor)
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 20)
                                                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                            }
                                                        Button (action: {
                                                            withAnimation {
                                                                calculationsSheetShown = true
                                                            }
                                                        }) {
                                                            HStack {
                                                                Label("Calculated Divisions", systemImage: "function")
                                                                Spacer()
                                                                Image(systemName: "chevron.right")
                                                            }
                                                            .foregroundColor(division.theme.textColor)
                                                            .font(.headline)
                                                            .padding(.vertical, 25)
                                                            .padding(.horizontal)
                                                        }
                                                    }
                                                    .matchedGeometryEffect(id: "calculationsBG", in: namespace)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    
                                                    HStack {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .fill(division.theme.mainColor)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .fill(Material.thin)
                                                                }
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                                }
                                                            Label(division.getStringDate(), systemImage: "calendar")
                                                                .padding(.horizontal)
                                                                .padding(.vertical,10)
                                                        }
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        Spacer()
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .fill(division.theme.mainColor)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .fill(Material.thin)
                                                                }
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                                }
                                                            Label("\(division.total, specifier: "%.2f") zł", systemImage: "banknote")
                                                                .padding(.horizontal)
                                                                .padding(.vertical,10)
                                                        }
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    }
                                                    HStack {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .fill(division.theme.mainColor)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .fill(Material.thin)
                                                                }
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                                }
                                                            Label("\(division.people.count)", systemImage: "person.2")
                                                                .padding(.horizontal)
                                                                .padding(.vertical,10)
                                                        }
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        Spacer()
                                                        Button(action: {
                                                            withAnimation {
                                                                data = division.data
                                                                editDetailsSheetShown = true
                                                            }
                                                        }) {
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 20)
                                                                    .fill(division.theme.mainColor)
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 20)
                                                                            .fill(Material.thin)
                                                                    }
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 20)
                                                                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                                    }
                                                                HStack {
                                                                    Spacer()
                                                                    Image(systemName: "gear")
                                                                    Spacer()
                                                                    Image(systemName: "chevron.right")
                                                                }
                                                                .padding(.horizontal)
                                                                .padding(.vertical,10)
                                                            }
                                                        }
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .matchedGeometryEffect(id: "editDivisionDetails", in: namespace)
                                                        .matchedGeometryEffect(id: "editDivisionCancel", in: namespace)
                                                        .matchedGeometryEffect(id: "editDivisionConfirm", in: namespace)
                                                    }
                                                }
                                                .foregroundColor(division.theme.textColor)
                                                .font(.footnote.bold())
                                                .padding()
                                            }
                                            .fixedSize(horizontal: false, vertical: true)
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(Material.thin)
                                                    .matchedGeometryEffect(id: "bottomBG", in: namespace)
                                                VStack (alignment: .leading){
                                                    VStack {
                                                        Text("People & Expenses")
                                                            .font(.footnote.bold())
                                                            .foregroundColor(.primary)
                                                    }
                                                    .padding([.leading, .top])
                                                    List {
                                                        ForEach(division.people.sorted()) { person in
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 20)
                                                                    .fill(Color(UIColor.systemBackground))
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 20)
                                                                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                                    }
                                                                VStack {
                                                                    HStack {
                                                                        Label("\(person.name)", systemImage: "person")
                                                                            .font(.headline)
                                                                            .labelStyle(DualColorLabel(iconColor: division.theme.mainColor))
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
                                                    .listStyle(.plain)
                                                    .modifier(ListBackgroundModifier())
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
                                                    .fill(division.theme.mainColor)
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
                                                        .foregroundColor(division.theme.textColor)
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
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive { saveAction() }
                }
            }
        }
    }
}

struct SingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDivisionView(division: .constant(Division.sampleDivisions[1]), namespace: Namespace.init().wrappedValue, backButtonShown: .constant(false), saveAction: {})
            .preferredColorScheme(.light)
        
        SingleDivisionView(division: .constant(Division.sampleDivisions[1]), namespace: Namespace.init().wrappedValue, backButtonShown: .constant(false), saveAction: {})
            .preferredColorScheme(.dark)
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
