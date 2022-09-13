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
    
    @State private var newPeople: [Person] = []
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    
    @Namespace var namespace
    
    let mainColor = Color("MainColor")
    let mainDarkerColor = Color(UIColor(Color("MainColor")).darker())
    
    init(divisions: Binding<[Division]>) {
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._divisions = divisions
    }
    
    var body: some View {
        return VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                //.fill(LinearGradient(mainColor,mainDarkerColor)) // mozna jakis obrazek cool
                    .fill(mainColor)
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.15, alignment: .center)
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                
                Text("DivCost")
                    .foregroundColor(.black)
                    .padding(20)
                    .font(.system(size: 60).weight(.bold))
                    .offset(x: 0, y: UIScreen.main.bounds.height*(-0.01))
            }
            .fixedSize()
            Group {
                if showEditView {
                    ZStack {
                        VStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(mainColor)
                                    .shadow(color: .black.opacity(0.3), radius: 6, x: 1, y: 1)
                                
                                List {
                                    Section {
                                        Text("New Division:")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(.white)
                                            TextField("Division Name", text: $newDivisionName)
                                                .padding()
                                        }
                                        Text("New People:")
                                            .font(.headline)
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(.white)
                                            HStack {
                                                TextField("New Person", text: $newPerson)
                                                Spacer()
                                                Button(action: {
                                                    withAnimation {
                                                        newPeople.append(Person(name: newPerson))
                                                    }
                                                    newPerson = ""
                                                }) {
                                                    Image(systemName: "plus")
                                                }
                                                .disabled(newPerson.isEmpty)
                                            }
                                            //.padding(.leading)
                                            .padding()
                                        }
                                        ForEach(newPeople) { person in
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(.white)
                                                Text(person.name)
                                                    .padding()
                                            }
                                        }
                                        .onDelete { indices in
                                            newPeople.remove(atOffsets: indices)
                                        }
                                        
                                        
                                        
                                        HStack {
                                            Button(action: {
                                                withAnimation {
                                                    data.divisions.append(Division(name: newDivisionName, people: newPeople))
                                                }
                                                newPerson = ""
                                                newDivisionName = ""
                                                withAnimation {
                                                    newPeople.removeAll()
                                                }
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .fill(Color.black.opacity(0.4))
                                                    Image(systemName: "plus")
                                                        .foregroundColor(mainDarkerColor)
                                                        .font(.headline)
                                                        .padding()
                                                }
                                            }
                                            .opacity((newDivisionName.isEmpty || newPeople.isEmpty) ? 0 : 1)
                                            .disabled(newDivisionName.isEmpty || newPeople.isEmpty)
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    
                                    Section {
                                        Text("Other Divisions:")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        ForEach(data.divisions) { division in   //cos sie pierdoliii - whitebox widmo po dodaniu
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(.white)
                                                Text(division.name)
                                                    .padding()
                                            }
                                            .listRowBackground(Color.clear)
                                            .listRowSeparator(.hidden)
                                        }
                                        .onDelete { indices in
                                            data.divisions.remove(atOffsets: indices)
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                                .listStyle(.plain)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                            }
                            .padding(.horizontal)
                            .matchedGeometryEffect(id: "mainCard", in: namespace)
                        }
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(mainColor, lineWidth: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.horizontal)
                            .matchedGeometryEffect(id: "mainCard", in: namespace)
                        VStack {
                            Spacer()
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.red.opacity(0.5))
                                    Button(action: {
                                        withAnimation {
                                            showEditView = false
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.headline)
                                            .foregroundColor(.darkRed)
                                            .padding(20)
                                    }
                                }
                                .fixedSize()
                                .matchedGeometryEffect(id: "cancelButton", in: namespace)
                                Spacer()
                                withAnimation {
                                    ZStack {
                                        Circle()
                                            .fill(.black.opacity(0.4))
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
                                                .foregroundColor(mainDarkerColor)
                                                .padding(20)
                                        }
                                    }
                                    .fixedSize()
                                    .matchedGeometryEffect(id: "confirmButton", in: namespace)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                }
                else {
                    ZStack {
                        //na tło miejsce
                        VStack (alignment: .center){
                            List {
                                Section {
                                    ForEach($divisions) { $division in
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.white)
                                                .shadow(color: .black.opacity(0.3), radius: 3, x: 1, y: 1)
                                            HStack {
                                                Text(division.name)
                                                    .font(.headline)
                                                Spacer()
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .fill(Color.white)
                                                        .overlay(RoundedRectangle(cornerRadius: 20).offset(x: -1, y: -1).stroke(.black.opacity(0.3)).blur(radius: 2).clipShape(RoundedRectangle(cornerRadius: 20)))
                                                    Label("\(division.people.count)", systemImage: "person.2.fill")
                                                        .labelStyle(DualColorLabel(iconColor: mainDarkerColor))
                                                        .font(.caption)
                                                        .padding(10)
                                                }
                                                .fixedSize()
                                                Image(systemName: "chevron.right")
                                                    .font(.headline)
                                            }
                                            .padding(20)
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                }
                                .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
                        }
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(mainColor)
                                        .shadow(color: .black.opacity(0.3), radius: 3, x: 1, y: 1)
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
                }
            }
        }
        
    }
}

struct DivisionsView_Previews: PreviewProvider {
    static var previews: some View {
        DivisionsView(divisions: .constant(Division.sampleDivisions))
    }
}
