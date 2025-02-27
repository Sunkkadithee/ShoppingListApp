//
//  EditShoppingItemView.swift
//  shopping list
//
//  Created by Hamza Omar khan on 2025-02-26.
//

import SwiftUI

struct EditShoppingItemView: View {
    @State private var item: ShoppingItem
    var onSave: (ShoppingItem) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    init(item: ShoppingItem, onSave: @escaping (ShoppingItem) -> Void) {
        _item = State(initialValue: item)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $item.name)
                    TextField("Price", text: $item.price)
                        .keyboardType(.decimalPad)
                    TextField("Category", text: $item.category)
                }
                
                Section {
                    Toggle("Purchased", isOn: $item.purchased)
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    onSave(item)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
