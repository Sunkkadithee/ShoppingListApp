import SwiftUI

// Data model for an item in the shopping list
struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var price: String
    var category: String
    var purchased: Bool
}

struct ShoppingListDetailView: View {
    var listName: String
    
    // State variables
    @State private var items: [ShoppingItem] = [
        ShoppingItem(name: "Pork (2)", price: "$76.00 (2 x $38.00)", category: "Meats", purchased: false),
        ShoppingItem(name: "Cucumbers", price: "$5.00", category: "Vegetable", purchased: false),
        ShoppingItem(name: "Rice", price: "$10", category: "Pasta, Rice & Cereals", purchased: false),
        ShoppingItem(name: "Tooth brush", price: "$15", category: "Personal care", purchased: false),
        ShoppingItem(name: "Butter", price: "$10", category: "Purchased", purchased: true),
        ShoppingItem(name: "Eggs", price: "$10", category: "Purchased", purchased: true)
    ]
    
    @State private var selectedItem: ShoppingItem? = nil
    
    // Body of the view
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: CartView(items: items)) {
                        Image(systemName: "cart.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                
                // Add Item Button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("ADD ITEM")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(red: 11/255, green: 61/255, blue: 145/255))
                
                // List of items
                List {
                    ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                        Section(header: Text(category).bold()) {
                            ForEach(groupedItems[category] ?? []) { item in
                                HStack {
                                    // Toggle purchased button
                                    Button(action: { togglePurchased(for: item) }) {
                                        Image(systemName: item.purchased ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(item.purchased ? .blue : .gray)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .strikethrough(item.purchased)
                                            .foregroundColor(item.purchased ? .gray : .black)
                                        Text(item.price)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // Edit button (Three-dot menu)
                                    Button(action: {
                                        selectedItem = item
                                    }) {
                                        Image(systemName: "ellipsis")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                    }
                                    .buttonStyle(BorderlessButtonStyle()) // Ensures only this button is interactive
                                }
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(listName)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            // Open Edit View only if `selectedItem` is set
            .sheet(item: $selectedItem) { item in
                EditShoppingItemView(item: item) { updatedItem in
                    if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
                        items[index] = updatedItem
                    }
                    selectedItem = nil // Close the sheet after editing
                }
            }
        }
    }
    
    // Computed property to group items by category
    private var groupedItems: [String: [ShoppingItem]] {
        Dictionary(grouping: items, by: { $0.category })
    }
    
    // Function to toggle the purchased status of an item
    private func togglePurchased(for item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].purchased.toggle()
        }
    }
}

