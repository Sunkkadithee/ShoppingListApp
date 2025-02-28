import SwiftUI

// Data model for a shopping list
struct ShoppingList: Identifiable {
    let id = UUID()
    var name: String  // Make name mutable to edit
    let itemCount: Int
}

struct ContentView: View {
    @State private var lists: [ShoppingList] = [
        ShoppingList(name: "Metro List", itemCount: 12),
        ShoppingList(name: "Farm Boy List", itemCount: 12),
        ShoppingList(name: "Walmart", itemCount: 12)
    ]
    
    @State private var isEditing = false
    @State private var editedListName = ""
    @State private var editingIndex: Int?
    
    // State to handle the deletion confirmation
    @State private var showDeleteAlert = false
    @State private var listToDelete: ShoppingList?

    var body: some View {
        NavigationView {
            VStack {
                // Title with buttons
                HStack {
                    Text("My Lists")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        // Add new list action
                        let newList = ShoppingList(name: "New List", itemCount: 0)
                        lists.append(newList)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                }
                .padding()
                .background(Color(red: 11/255, green: 61/255, blue: 145/255))

                // List of shopping lists
                List {
                    ForEach(lists.indices, id: \.self) { index in
                        NavigationLink(destination: ShoppingListDetailView(listName: lists[index].name)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(lists[index].name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("\(lists[index].itemCount) items")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.orange)
                                .cornerRadius(10)
                                
                                Spacer()
                            }
                        }
                        .swipeActions {
                            // Delete action first
                            Button(action: {
                                // Set the list to be deleted and show the alert
                                listToDelete = lists[index]
                                showDeleteAlert = true
                            }) {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)

                            // Edit action second
                            Button(action: {
                                // Set up for editing the list name
                                editingIndex = index
                                editedListName = lists[index].name
                                isEditing.toggle()
                            }) {
                                Label("Edit", systemImage: "pencil.circle.fill")
                            }
                            .tint(.blue)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
            }
            .background(Color(.systemBackground))
            .sheet(isPresented: $isEditing) {
                // Edit Name Modal
                VStack {
                    Text("Edit List Name")
                        .font(.title)
                        .padding()
                    
                    TextField("New name", text: $editedListName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    HStack {
                        Button("Cancel") {
                            isEditing = false
                        }
                        .padding()

                        Spacer()

                        Button("Save") {
                            if let editingIndex = editingIndex {
                                lists[editingIndex].name = editedListName
                            }
                            isEditing = false
                        }
                        .padding()
                        .disabled(editedListName.isEmpty)
                    }
                    .padding()
                }
                .padding()
            }
            // Confirmation Alert for Deletion
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this list?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let listToDelete = listToDelete {
                            deleteList(listToDelete)
                        }
                    },
                    secondaryButton: .cancel {
                        listToDelete = nil
                    }
                )
            }
            .navigationBarBackButtonHidden(true) // Hides the back button
        }
    }
    
    // Function to delete a list
    private func delete(at offsets: IndexSet) {
        lists.remove(atOffsets: offsets)
    }

    // Function to delete a specific list by object
    private func deleteList(_ list: ShoppingList) {
        if let index = lists.firstIndex(where: { $0.id == list.id }) {
            lists.remove(at: index)
        }
    }
}
