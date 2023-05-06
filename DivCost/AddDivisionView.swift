//
//  AddDivisionView.swift
//  DivCost
//
//  Created by Michał Rusinek on 12/04/2023.
//

import SwiftUI

struct AddDivisionView: View {
    @Binding var division: Division
    
    @State private var newPerson: String = ""
    
    var body: some View {
        List {
            Section ("New Division") {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(UIColor.systemBackground))
                        TextField("New Division Name", text: $division.name)
                            .padding(15)
                            .padding(.horizontal)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical,-5)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section ("New Theme") {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(UIColor.systemBackground))
                    ThemePickerView(selection: $division.theme)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section ("New Date") {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(UIColor.systemBackground))
                    DatePickerView(date: $division.date, color: division.theme.mainColor)
                        .padding()
                        .tint(division.theme.mainColor)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section ("New People") {
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
                            division.people.append(Person(name: newPerson))
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
                
                ForEach($division.people.sorted {$0.name.wrappedValue < $1.name.wrappedValue}) { $person in
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
                                division.people = Person.removePerson(people: division.people, personID: person.id)
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
        .background(division.theme.mainColor.opacity(0.1))
        .background(.ultraThinMaterial)
        .listStyle(.plain)
        .scrollDismissesKeyboard(.interactively)
        .interactiveDismissDisabled()
    }
}

struct AddDivisionView_Previwes: PreviewProvider {
    static var previews: some View {
        AddDivisionView(division: .constant(Division.emptyDivision))
    }
}
