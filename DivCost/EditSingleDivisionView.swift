//
//  EditSingleDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 09/09/2022.
//

import SwiftUI

struct EditSingleDivisionView: View {
    
    @Binding var data: Division.Data
    
    @State private var newDivisionName: String = ""
    @State private var newPerson: String = ""
    @Binding var newTheme: Theme
    @Binding var newDate: Date
    
    init(data: Binding<Division.Data>) {
        self._data = data
        self._newTheme = data.theme
        self._newDate = data.date
    }
    
    var body: some View {
        //        VStack {
        //            Spacer()
        //            ZStack {
        //                RoundedRectangle(cornerRadius: 30)
        //                    .fill(data.theme.mainColor)
        //                    .overlay {
        //                        RoundedRectangle(cornerRadius: 30)
        //                            .fill(Material.thin)
        //                    }
        //                List {
        //                    Text("Current Name: \(data.name)")
        //                        .font(.footnote.bold())
        //                        .listRowBackground(Color.clear)
        //                        .listRowSeparator(.hidden)
        //                        .foregroundColor(data.theme.textColor)
        //
        //                    ZStack {
        //                        RoundedRectangle(cornerRadius: 20)
        //                            .fill(Color(UIColor.systemBackground))
        //                            .overlay {
        //                                RoundedRectangle(cornerRadius: 20)
        //                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
        //                            }
        //                        HStack {
        //                            TextField("New Division Name", text: $newDivisionName)
        //                            Spacer()
        //                            Button(action: {
        //                                data.name = newDivisionName
        //                                newDivisionName = ""
        //                            }) {
        //                                Image(systemName: "checkmark")
        //                            }
        //                            .foregroundColor(.primary)
        //                            .disabled(newDivisionName.isEmpty)
        //                        }
        //                        .padding()
        //                    }
        //                    .listRowBackground(Color.clear)
        //                    .listRowSeparator(.hidden)
        //
        //                    Text("Theme")
        //                        .font(.footnote.bold())
        //                        .listRowBackground(Color.clear)
        //                        .listRowSeparator(.hidden)
        //                        .foregroundColor(data.theme.textColor)
        //                    ZStack {
        //                        RoundedRectangle(cornerRadius: 20)
        //                            .fill(Color(UIColor.systemBackground))
        //                            .overlay {
        //                                RoundedRectangle(cornerRadius: 20)
        //                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
        //                            }
        //                        ThemePickerView(selection: $newTheme)
        //                    }
        //                    .clipped()
        //                    .clipShape(RoundedRectangle(cornerRadius: 20))
        //                    .listRowBackground(Color.clear)
        //                    .listRowSeparator(.hidden)
        //
        //                    Text("Date")
        //                        .font(.footnote.bold())
        //                        .listRowBackground(Color.clear)
        //                        .listRowSeparator(.hidden)
        //                        .foregroundColor(data.theme.textColor)
        //                    ZStack {
        //                        RoundedRectangle(cornerRadius: 20)
        //                            .fill(Color(UIColor.systemBackground))
        //                            .overlay {
        //                                RoundedRectangle(cornerRadius: 20)
        //                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
        //                            }
        //                        DatePickerView(date: $newDate, color: data.theme.mainColor)
        //                            .padding()
        //                    }
        //                    .clipped()
        //                    .clipShape(RoundedRectangle(cornerRadius: 20))
        //                    .listRowBackground(Color.clear)
        //                    .listRowSeparator(.hidden)
        //
        //                    Text("People")
        //                        .font(.footnote.bold())
        //                        .listRowBackground(Color.clear)
        //                        .listRowSeparator(.hidden)
        //                        .foregroundColor(data.theme.textColor)
        //                    ZStack {
        //                        RoundedRectangle(cornerRadius: 20)
        //                            .fill(Color(UIColor.systemBackground))
        //                            .overlay {
        //                                RoundedRectangle(cornerRadius: 20)
        //                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
        //                            }
        //                        HStack {
        //                            TextField("New Person", text: $newPerson)
        //                            Spacer()
        //                            Button(action: {
        //                                withAnimation {
        //                                    data.people.append(Person(name: newPerson))
        //                                }
        //                                newPerson = ""
        //                            }) {
        //                                Image(systemName: "plus")
        //                            }
        //                            .disabled(newPerson.isEmpty)
        //                        }
        //                        .padding()
        //                    }
        //                    .listRowBackground(Color.clear)
        //                    .listRowSeparator(.hidden)
        //                    ForEach(data.people) { person in
        //                        ZStack {
        //                            RoundedRectangle(cornerRadius: 20)
        //                                .fill(Color(UIColor.systemBackground))
        //                                .overlay {
        //                                    RoundedRectangle(cornerRadius: 20)
        //                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
        //                                }
        //                            Text(person.name)
        //                                .padding()
        //                        }
        //                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        //                            Button(role: .destructive) {
        //                                withAnimation {
        //                                    data.removePerson(personID: person.id)
        //                                }
        //                            } label: {
        //                                Label("Delete", systemImage: "trash.fill")
        //                            }
        //                            .tint(.red)
        //                        }
        //                    }
        ////                    .onDelete { indices in
        ////                        withAnimation {
        ////                            data.people.remove(atOffsets: indices)
        ////                        }
        ////                    }
        //                    //.padding(.leading)
        //                    .listRowBackground(Color.clear)
        //                    .listRowSeparator(.hidden)
        //
        //                    Spacer(minLength: 100)
        //                        .listRowBackground(Color.clear)
        //                        .listRowSeparator(.hidden)
        //                }
        //                .listStyle(.plain)
        //                .modifier(ListBackgroundModifier())
        //                .clipShape(RoundedRectangle(cornerRadius: 30))
        //
        //                RoundedRectangle(cornerRadius: 30)
        //                    .stroke(data.theme.mainColor, lineWidth: 20)
        //                    .clipShape(RoundedRectangle(cornerRadius: 30))
        //            }
        //        }
        
        List {
            Section ("Current Name: \(data.name)") {
                HStack {
                    //moze po prostu zeby bylo napisane do zmiany a nie wpisanie nowej i guzik ???
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        TextField("New Division Name", text: $newDivisionName)
                            .padding(15)
                            .padding(.horizontal)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Button(action: {
                        data.name = newDivisionName
                        newDivisionName = ""
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title2.bold())
                    }
                    .foregroundColor(.primary)
                    .disabled(newDivisionName.isEmpty)
                    .padding(.trailing)
                }
                .padding(.vertical,-5)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section ("Theme") {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(UIColor.systemBackground))
                    ThemePickerView(selection: $newTheme)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section ("Date") {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(UIColor.systemBackground))
                    DatePickerView(date: $newDate, color: newTheme.mainColor)
                        .padding()
                        .tint(newTheme.mainColor)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section ("People") {
                HStack {
                    //moze po prostu zeby bylo napisane do zmiany a nie wpisanie nowej i guzik ???
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        TextField("New Person", text: $newPerson)
                            .padding(15)
                            .padding(.horizontal)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            data.people.append(Person(name: newPerson))
                        }
                        newPerson = ""
                    }) {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                    }
                    .foregroundColor(.primary)
                    .disabled(newPerson.isEmpty)
                    .padding(.trailing)
                }
                .padding(.vertical,-5)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color(UIColor.systemBackground))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
//                        }
//                    HStack {
//                        TextField("New Person", text: $newPerson)
//                        Spacer()
//                        Button(action: {
//                            withAnimation {
//                                data.people.append(Person(name: newPerson))
//                            }
//                            newPerson = ""
//                        }) {
//                            Image(systemName: "plus")
//                        }
//                        .disabled(newPerson.isEmpty)
//                    }
//                    .padding()
//                }
//                .padding(.vertical,-5)
//                .listRowBackground(Color.clear)
//                .listRowSeparator(.hidden)
                ForEach(data.people) { person in
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        Text(person.name)
                            .padding(15)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                data.removePerson(personID: person.id)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
                .padding(.vertical,-5)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Spacer(minLength: 100)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .background(newTheme.mainColor.opacity(0.1))
        .background(.ultraThinMaterial)
        .listStyle(.plain)
        
    }
}

struct EditSingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSingleDivisionView(data: .constant(Division.sampleDivisions[1].data))
    }
}
