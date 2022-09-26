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
    
    @State private var showEditView = false
    @State private var showDivisionView = false
    @State private var chosenDivisionID = UUID()
    
    @State private var backButtonShown = true
    
    @State private var newPeople: [Person] = []
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    
    @State private var topOffset = -UIScreen.main.bounds.height*0.5
    @State private var bottomOffset = UIScreen.main.bounds.height
    
    @Namespace var namespace
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    let theme: Theme = .div_cost
    
    init(divisions: Binding<[Division]>, saveAction: @escaping ()->Void) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._divisions = divisions
        self.saveAction = saveAction
    }
    
    var body: some View {
        Group {
            if showDivisionView {
                ZStack {
                    
                    SingleDivisionView(division: Division.getFromID(divisions: $divisions, ID: chosenDivisionID), namespace: namespace, backButtonShown: $backButtonShown, saveAction: saveAction)
                    
                    Group {
                        if backButtonShown {
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
                                                showDivisionView = false
                                            }
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                                .padding(20)
                                        }
                                    }
                                    .fixedSize()
                                    .matchedGeometryEffect(id: "cancelButton", in: namespace)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                
                            }
                        } else {}
                    }
                }
            }
            
            else {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                        //.fill(LinearGradient(mainColor,mainDarkerColor)) // mozna jakis obrazek cool
                            .fill(theme.mainColor)
                            .ignoresSafeArea()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.15, alignment: .center)
                            //.shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                            .matchedGeometryEffect(id: "titleBG", in: namespace)
                        
                        Text("DivCost")
                            .foregroundColor(.black)
                            .padding(20)
                            .font(.system(size: 60).weight(.bold))
                            .offset(x: 0, y: UIScreen.main.bounds.height*(-0.01))
                            .offset(x: 0, y: topOffset*0.5)
                            
                    }
                    .fixedSize()
                    .offset(x: 0, y: topOffset)
                    
                    Group {
                        if showEditView {
                            ZStack {
                                
                                EditMultipleDivisionsView(data: $data, namespace: namespace)
                                
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
                                                    showEditView = false
                                                }
                                            }) {
                                                Image(systemName: "xmark")
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .padding(20)
                                            }
                                        }
                                        .fixedSize()
                                        .matchedGeometryEffect(id: "cancelButton", in: namespace)
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
                                                    var multipleDivisions = MultipleDivisions(divisions: divisions)
                                                    multipleDivisions.update(from: data)
                                                    divisions = multipleDivisions.unwrap()
                                                    //divisions = divisions.sorted() //moze wg daty sortowanie kiedys
                                                    withAnimation {
                                                        showEditView = false
                                                    }
                                                }) {
                                                    Image(systemName: "checkmark")
                                                        .font(.headline)
                                                        .foregroundColor(.primary)
                                                        .padding(20)
                                                }
                                            }
                                            .fixedSize()
                                            .matchedGeometryEffect(id: "confirmButton", in: namespace)
                                        }
                                    }
                                    .padding(.horizontal)                                }
                            }
                        }
                        else {
                            VStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Material.thin)
                                        .ignoresSafeArea()
                                        .matchedGeometryEffect(id: "topBG", in: namespace)
                                    ScrollView {
                                        ForEach(divisions.sorted()) { division in
                                            Button(action: {
                                                withAnimation {
                                                    showDivisionView = true
                                                } //!!!!!!!!!!
                                                chosenDivisionID = division.id
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color(UIColor.systemBackground))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 20)
                                                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                        }
                                                    HStack {
                                                        VStack (alignment: .leading){
                                                            Text(division.name)
                                                                .font(.title.bold())
                                                                .foregroundColor(.primary)
                                                            Spacer()
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(division.theme.mainColor)
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 10)
                                                                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                                    }
                                                                HStack {
                                                                    Label(division.getStringDate(), systemImage: "calendar")
                                                                    Spacer()
                                                                    Label("\(division.total, specifier: "%.2f") zł", systemImage: "banknote")
                                                                    Spacer()
                                                                    Label("\(division.people.count)", systemImage: "person.2")
                                                                }
                                                                .font(.caption)
                                                                .padding(10)
                                                                .foregroundColor(division.theme.textColor)
                                                            }
                                                            .fixedSize(horizontal: false, vertical: true)
                                                        }
                                                        Spacer()
                                                        Image(systemName: "chevron.right")
                                                            .font(.headline)
                                                            .foregroundColor(.primary)
                                                    }
                                                    .padding(20)
                                                }
                                                .fixedSize(horizontal: false, vertical: true)
                                            }
                                            
                                        }
                                        .matchedGeometryEffect(id: "title", in: namespace)
                                        .padding()
                                    }
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(theme.mainColor)
                                                    .overlay {
                                                        Circle()
                                                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                                    }
                                                    //.shadow(color: .black.opacity(0.3), radius: 3, x: 1, y: 1)
                                                Button(action: {
                                                    let multipleDivisions = MultipleDivisions(divisions: divisions)
                                                    data = multipleDivisions.multipleData
                                                    withAnimation {
                                                        showEditView = true
                                                    }
                                                }) {
                                                    Image(systemName: "plus")
                                                        .font(.headline)
                                                        .foregroundColor(.black)
                                                        .padding(20)
                                                }
                                            }
                                            .fixedSize()
                                            .matchedGeometryEffect(id: "mainCard", in: namespace)
                                            
                                            .matchedGeometryEffect(id: "cancelButton", in: namespace)
                                            .matchedGeometryEffect(id: "confirmButton", in: namespace)
                                        }
                                        .padding(.trailing)
                                    }
                                }
                                .offset(x: 0, y: bottomOffset)
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

struct DivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        DivisionsView(divisions: .constant(Division.sampleDivisions), saveAction: {})
    }
}
