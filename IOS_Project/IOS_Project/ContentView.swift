//
//  ContentView.swift
//  IOS_Project
//
//  Created by Hamza Omar khan on 2025-03-12.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: ShoppingList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.name, ascending: true)]
    ) var shoppingLists: FetchedResults<ShoppingList>
    
    @State private var newListName: String = ""
    @State private var showNewListModal: Bool = false
    @State private var editList: ShoppingList?
    @State private var editName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("My Shopping Lists")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        // Add new list action
                        showNewListModal = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                }
                .padding()
                .background(Color.blue)
                
                List {
                    ForEach(shoppingLists) { list in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(list.name ?? "Unnamed List")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(list.itemCount) items")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange)
                            .cornerRadius(10)
                            
                            Spacer()
                        
                        }
                        .swipeActions {
                            Button(action: {
                                // Delete action
                                viewContext.delete(list)
                                saveContext()
                            }) {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)

                            Button(action: {
                                editList = list
                                editName = list.name ?? ""
                            }) {
                                Label("Edit", systemImage: "pencil.circle.fill")
                            }
                            .tint(.blue)
                        }
                    }
                    .onDelete(perform: deleteList)
                }
                .listStyle(PlainListStyle())
            }
            .background(Color(.systemBackground))
            .sheet(isPresented: $showNewListModal) {
                VStack {
                    Text("Enter New List Name")
                        .font(.title)
                        .padding()
                    
                    TextField("New List Name", text: $newListName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Cancel") {
                            showNewListModal = false
                            newListName = ""
                        }
                        .padding()
                        .foregroundColor(.red)

                        Spacer()

                        Button("Save") {
                            addList()
                            showNewListModal = false
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(newListName.isEmpty)
                    }
                    .padding()
                }
                .padding()
            }
            .sheet(item: $editList) { list in
                VStack {
                    Text("Edit List Name")
                        .font(.title)
                        .padding()
                    
                    TextField("New Name", text: $editName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Cancel") {
                            editList = nil
                            editName = ""
                        }
                        .padding()
                        .foregroundColor(.red)

                        Spacer()

                        Button("Save") {
                            updateList(list)
                            editList = nil
                            editName = ""
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(editName.isEmpty)
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
    
    func addList() {
        let newList = ShoppingList(context: viewContext)
        newList.id = UUID()
        newList.name = newListName
        newList.itemCount = 0
        saveContext()
        
        newListName = ""
    }
    
    func deleteList(offsets: IndexSet) {
        for index in offsets {
            let list = shoppingLists[index]
            viewContext.delete(list)
        }
        saveContext()
    }
    
    func updateList(_ list: ShoppingList) {
        list.name = editName
        saveContext()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save Core Data: \(error.localizedDescription)")
        }
    }
}
