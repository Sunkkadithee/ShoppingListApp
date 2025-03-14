import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchQuery: String = ""
    @State private var items: [String] = ["Apple", "Banana", "Carrot", "Milk", "Eggs", "Bread"]
    @State private var selectedItems: Set<String> = []
    
    var onDone: (Set<String>) -> Void // Closure to pass back selected items
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section with Background
            VStack(spacing: 15) {
                // Title
                Text("Grocery List")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Search Bar
                HStack {
                    TextField("Search or Add Item", text: $searchQuery)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .overlay(
                            HStack {
                                Spacer()
                                if !searchQuery.isEmpty {
                                    Button(action: { searchQuery = "" }) {
                                        Image(systemName: "x.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 10)
                                    }
                                }
                            }
                        )
                        .padding(.horizontal, 15)
                }
            }
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity)
            .background(Color(red: 11/255, green: 61/255, blue: 145/255)) // Background color

            Divider()

            // List of Items
            List {
                ForEach(items.filter { searchQuery.isEmpty || $0.lowercased().contains(searchQuery.lowercased()) }, id: \.self) { item in
                    HStack {
                        Text(item)
                            .font(.body)
                            .foregroundColor(selectedItems.contains(item) ? .white : .primary)
                            .padding(10)
                            .background(selectedItems.contains(item) ? Color.orange : Color.clear)
                            .cornerRadius(10)
                            .animation(.easeInOut(duration: 0.2), value: selectedItems.contains(item))
                        
                        Spacer()
                        
                        Button(action: {
                            if selectedItems.contains(item) {
                                selectedItems.remove(item)
                            } else {
                                selectedItems.insert(item)
                            }
                        }) {
                            Image(systemName: selectedItems.contains(item) ? "checkmark.circle.fill" : "plus.circle.fill")
                                .foregroundColor(selectedItems.contains(item) ? .orange : .blue)
                                .font(.title)
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                // Custom Item Input
                if !items.contains(searchQuery) && !searchQuery.isEmpty {
                    HStack {
                        Text("Add '\(searchQuery)'")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                            items.append(searchQuery)
                            selectedItems.insert(searchQuery)
                            searchQuery = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .listStyle(PlainListStyle())

            Spacer()

            // Done Button
            Button(action: {
                onDone(selectedItems) // Pass selected items back
                presentationMode.wrappedValue.dismiss() // Dismiss the modal
            }) {
                Text("DONE")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
        }
        .navigationBarHidden(true)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(onDone: { _ in })
    }
}
