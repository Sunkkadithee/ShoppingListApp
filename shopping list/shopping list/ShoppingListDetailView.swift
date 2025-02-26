
//  ShoppingListDetailView.swift
//  shopping list
//
//  Created by Pang Sunkkadithee on 2025-02-25.
//

//

import SwiftUI

// Data model for an item in the shopping list
struct ShoppingItem: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let category: String
    var purchased: Bool
}

struct ShoppingListDetailView: View {
    var listName: String
    @State private var items: [ShoppingItem] = [
        ShoppingItem(name: "Pork (2)", price: "$76.00 (2 x $38.00)", category: "Meats", purchased: false),
        ShoppingItem(name: "Cucumbers", price: "$5.00", category: "Vegetable", purchased: false),
        ShoppingItem(name: "Rice", price: "$10", category: "Pasta, Rice & Cereals", purchased: false),
        ShoppingItem(name: "Tooth brush", price: "$15", category: "Personal care", purchased: false),
        ShoppingItem(name: "Butter", price: "$10", category: "Purchased", purchased: true),
        ShoppingItem(name: "Eggs", price: "$10", category: "Purchased", purchased: true)
    ]
    
    var body: some View {
        VStack {
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
            .background(Color(red: 11/255, green: 61/255, blue: 145/255)) // Background for title and button
            
            // List of items
            List {
                ForEach(groupedItems.keys.sorted(), id: \ .self) { category in
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
                                
                                Spacer() // Pushes the edit button to the right
                                
                                // Edit button
                                Button(action: { editItem(item) }) {
                                    Image(systemName: "ellipsis")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
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
                    .font(.title) // Makes the text larger
                    .fontWeight(.bold) // Makes the text thicker (bold)
            }
        }
    }
    
    private var groupedItems: [String: [ShoppingItem]] {
        Dictionary(grouping: items, by: { $0.category })
    }
    
    private func togglePurchased(for item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].purchased.toggle()
        }
    }
    
    private func editItem(_ item: ShoppingItem) {
        print("Edit button tapped for \(item.name)")
        // Add your edit functionality here
    }
}
