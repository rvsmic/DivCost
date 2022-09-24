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
    
//    let themeColor: Color
//    let themeDarkerColor: Color
//    let themeLighterColor: Color
    
    var namespace: Namespace.ID
    
    init(data: Binding<Division.Data>, namespace: Namespace.ID) {
        self._data = data
//        self.themeColor = themeColor
//        self.themeDarkerColor = Color(UIColor(themeColor).darker().darker())
//        self.themeLighterColor = themeColor.opacity(0.2)
        self.namespace = namespace
        self._newTheme = data.theme
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(data.theme.mainColor)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Material.thin)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                }
            VStack (alignment: .leading){
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBackground))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                        }
                    HStack {
                        TextField("New Division Name", text: $newDivisionName)
                        Spacer()
                        Button(action: {
                            data.name = newDivisionName
                            newDivisionName = ""
                        }) {
                            Image(systemName: "checkmark")
                        }
                        .foregroundColor(.primary)
                        .disabled(newDivisionName.isEmpty)
                    }
                    .padding()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                Text("Theme")
                    .font(.footnote.bold())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .foregroundColor(data.theme.textColor)
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBackground))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                        }
                    ThemePickerView(selection: $newTheme)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("People")
                    .font(.footnote.bold())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .foregroundColor(data.theme.textColor)
                ForEach(data.people) { person in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.systemBackground))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                            }
                        Text(person.name)
                    }
                }
                .onDelete { indices in
                    withAnimation {
                        data.people.remove(atOffsets: indices)
                    }
                }
                //.padding(.leading)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemBackground))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                        }
                    HStack {
                        TextField("New Person", text: $newPerson)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                data.people.append(Person(name: newPerson))
                            }
                            newPerson = ""
                        }) {
                            Image(systemName: "plus")
                        }
                        .disabled(newPerson.isEmpty)
                    }
                    .padding(.horizontal)
                    //.padding(.leading)
                    
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                Spacer(minLength: 50)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            //.listStyle(.plain)
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        
        .matchedGeometryEffect(id: "editDivisionDetails", in: namespace)
        
        //.matchedGeometryEffect(id: "editDivisionDetails", in: namespace)
        
        
//        List {
//            HStack {
//                TextField("New Division Name", text: $newDivisionName)
//                Spacer()
//                Button(action: {
//                    data.name = newDivisionName
//                    newDivisionName = ""
//                }) {
//                    Image(systemName: "checkmark")
//                }
//                .disabled(newDivisionName.isEmpty)
//            }
//            Text("People:")
//                .font(.headline)
//            ForEach(data.people) { person in
//                Text(person.name)
//            }
//            .onDelete { indices in
//                withAnimation {
//                    data.people.remove(atOffsets: indices)
//                }
//            }
//            .padding(.leading)
//            HStack {
//                TextField("New Person", text: $newPerson)
//                Spacer()
//                Button(action: {
//                    withAnimation {
//                        data.people.append(Person(name: newPerson))
//                    }
//                    newPerson = ""
//                }) {
//                    Image(systemName: "plus")
//                }
//                .disabled(newPerson.isEmpty)
//            }
//            .padding(.leading)
//        }
//        .navigationTitle(data.name)
    }
}

struct EditSingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSingleDivisionView(data: .constant(Division.sampleDivisions[1].data), namespace: Namespace.init().wrappedValue)
    }
}
