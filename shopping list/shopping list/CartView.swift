import SwiftUI

struct CartView: View {
    @State var items: [ShoppingItem]  // Make items mutable with @State
    
    // Get unpurchased items
    var unpurchasedItems: [ShoppingItem] {
        items.filter { !$0.purchased }
    }
    
    // Calculate the total cost of unpurchased items
    var totalCost: Double {
        unpurchasedItems
            .compactMap { Double($0.price.replacingOccurrences(of: "$", with: "")) }
            .reduce(0, +)
    }
    
    // Tax rate and tax amount
    let taxRate: Double = 0.13
    
    var taxAmount: Double {
        totalCost * taxRate
    }
    
    // Final amount after adding tax
    var finalAmount: Double {
        totalCost + taxAmount
    }
    
    var body: some View {
        VStack {
            // Header with shopping summary
            Text("Shopping Cart")
                .font(.title)
                .bold()
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .center)

            Divider()
                .padding(.vertical)

            // List of unpurchased items with their quantity and price
            List {
                ForEach(unpurchasedItems) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text("Qty: \(item.name.split(separator: "(").last?.split(separator: ")").first ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(item.price)
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 5)
                    .swipeActions {
                        // Swipe Action for Deleting
                        Button {
                            deleteItem(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                        .tint(.red)
                        
                        // Swipe Action for Editing
                        Button {
                            editItem(item)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                .foregroundColor(.blue)
                        }
                        .tint(.blue)
                    }
                }
                .onDelete(perform: deleteItems)  // Enable swipe to delete in case swipeActions is not used
            }
            .listStyle(PlainListStyle())
            
            Divider()
                .padding(.vertical)

            // Cost breakdown
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Total Cost")
                        .font(.subheadline)
                    Spacer()
                    Text("$\(totalCost, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("Tax (13%)")
                        .font(.subheadline)
                    Spacer()
                    Text("$\(taxAmount, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Text("Final Amount")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    Text("$\(finalAmount, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .bold()
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            // Remove Cart Button
            Button(action: {
                // Action to remove all items from the cart
                items.removeAll()  // This will delete all items in the cart
            }) {
                Text("Remove Cart")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
    
    // Function to delete selected items
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)  // Remove the item at the specified index
    }
    
    // Function to delete a specific item
    func deleteItem(_ item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
    
    // Function to edit a specific item
    func editItem(_ item: ShoppingItem) {
        // For example, show an alert or navigate to an edit screen
        // In a real app, you can present a modal or a new view for editing
        print("Editing \(item.name)")
    }
}

