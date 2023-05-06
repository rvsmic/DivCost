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
        List {
            Section ("Change Name") {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        TextField("New Division Name", text: $data.name)
                            .padding(15)
                            .padding(.horizontal)
                    }
                    .fixedSize(horizontal: false, vertical: true)
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
                ForEach($data.people.sorted {$0.name.wrappedValue.lowercased() < $1.name.wrappedValue.lowercased()}) { $person in
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        TextField("Person Name", text: $person.name)
                            .multilineTextAlignment(.center)
                            .padding(15)
                            .padding(.horizontal)
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
            Spacer(minLength: 200)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .background(newTheme.mainColor.opacity(0.1))
        .background(.ultraThinMaterial)
        .listStyle(.plain)
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            newDivisionName = data.name
        }
        .interactiveDismissDisabled()
    }
}

struct EditSingleDivisionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSingleDivisionView(data: .constant(Division.sampleDivisions[1].data))
        
    }
}
