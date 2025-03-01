import SwiftUI

struct AddItemView: View {
    let availableItems = [
        ShoppingItem(name: "Apple", price: "$1.00", category: "Fruits", quantity: "1", description: "Red apple", purchased: false),
        ShoppingItem(name: "Banana", price: "$0.50", category: "Fruits", quantity: "1", description: "Yellow banana", purchased: false),
        ShoppingItem(name: "Carrot", price: "$0.75", category: "Vegetables", quantity: "1", description: "Fresh carrots", purchased: false),
        ShoppingItem(name: "Milk", price: "$2.00", category: "Dairy", quantity: "1", description: "Whole milk", purchased: false),
        ShoppingItem(name: "Bread", price: "$1.50", category: "Bakery", quantity: "1", description: "Fresh bread", purchased: false)
    ]
    
    @State private var selectedItems: [ShoppingItem] = []
    @Environment(\.presentationMode) var presentationMode
    var onAdd: (ShoppingItem) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                List(availableItems) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Button(action: {
                            if !selectedItems.contains(where: { $0.id == item.id }) {
                                selectedItems.append(item)
                            }
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                Button("Done") {
                    for item in selectedItems {
                        onAdd(item)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Add Items")
        }
    }
}


