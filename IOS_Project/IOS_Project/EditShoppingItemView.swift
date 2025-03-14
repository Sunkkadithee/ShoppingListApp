import SwiftUI

struct EditShoppingItemView: View {
    @State private var item: ShoppingItem
    var onSave: (ShoppingItem) -> Void
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    // List of available categories
    let categories = [
        "Fruit 🍎",
        "Veggie 🥕",
        "Cloth 👗",
        "Technology 💻",
        "Beverages 🥤",
        "Snacks 🍿",
        "Cleaning 🧽",
        "Personal Care 🧴",
        "Furniture 🛋️",
        "Toys 🧸",
        "Health 🏥",
        "Sports ⚽",
        "Electronics 📱",
        "Books 📚",
        "Stationery 🖊️",
        "Pets 🐾",
        "Home Decor 🏠",
        "Jewelry 💍",
        "Tools 🔧",
        "Baby Care 🍼",
        "Other... 🤔"
    ]
    
    init(item: ShoppingItem, onSave: @escaping (ShoppingItem) -> Void) {
        _item = State(initialValue: item)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    // Binding for optional String properties
                    TextField("Name", text: Binding(
                        get: { item.name ?? "" },
                        set: { item.name = $0.isEmpty ? nil : $0 }
                    ))
                    
                    // Price with fixed "$" symbol
                    HStack {
                        Text("$") // Fixed dollar sign
                            .font(.title2)
                            .foregroundColor(.black)
                        
                        TextField("Price", text: Binding(
                            get: { item.price ?? "" },
                            set: { item.price = $0.isEmpty ? nil : $0 }
                        ))
                        .keyboardType(.decimalPad)
                        .frame(width: 150)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    }
                    
                    // Category picker
                    Picker("Category", selection: $item.category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category as String?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Menu style for iOS
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
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
                    saveItem() // Call save function to update Core Data
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveItem() {
        // Save changes to Core Data
        do {
            try viewContext.save() // Save the context
        } catch {
            print("Error saving item: \(error.localizedDescription)")
        }
        
        onSave(item) // Ensure the parent view is updated with the modified item
    }
}
