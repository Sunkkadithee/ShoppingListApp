import SwiftUI

struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var price: String
    var category: String
    var quantity: String
    var description: String
    var purchased: Bool
}

struct ShoppingListDetailView: View {
    var listName: String
    
    @State private var items: [ShoppingItem] = [
        ShoppingItem(name: "Pork (2)", price: "$76.00 (2 x $38.00)", category: "Meats", quantity: "2", description: "Fresh pork meat", purchased: false),
        ShoppingItem(name: "Cucumbers", price: "$5.00", category: "Vegetable", quantity: "1", description: "Fresh cucumbers", purchased: false),
        ShoppingItem(name: "Butter", price: "$10", category: "Dairy", quantity: "1", description: "Salted butter", purchased: true),
        ShoppingItem(name: "Eggs", price: "$10", category: "Dairy", quantity: "12", description: "A dozen eggs", purchased: true)
    ]
    
    @State private var showAddItemView = false
    @State private var selectedItem: ShoppingItem? = nil
    @State private var showActionSheet = false
    @State private var actionSheetItem: ShoppingItem? = nil
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Header Section (Add Item Button)
                VStack {
                    NavigationLink(destination: AddItemView { newItem in
                        items.append(newItem)  // Agregar el ítem seleccionado
                    }) {
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
                }
                .background(Color(red: 11/255, green: 61/255, blue: 145/255)) // Fondo de la cabecera
                .zIndex(1) // Aseguramos que este botón esté encima del contenido deslizante
                
                // Contenido deslizante (ScrollView)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                            VStack(alignment: .leading) {
                                Text(category)
                                    .bold()
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                
                                ForEach(groupedItems[category] ?? []) { item in
                                    HStack {
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
                                        
                                        Button(action: {
                                            actionSheetItem = item
                                            showActionSheet.toggle() // Mostrar hoja de acciones
                                        }) {
                                            Image(systemName: "ellipsis")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.top, 20) // Aseguramos que el contenido no se superponga con el encabezado
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(listName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10) // Ajustamos la posición
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView(items: items)) {
                        ZStack {
                            Image(systemName: "cart.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.top, 10) // Ajustamos la posición
                            
                            if items.filter({ $0.purchased }).count > 0 {
                                Text("\(items.filter { $0.purchased }.count)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 18, y: -11.5)
                            }
                        }
                    }
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Actions for \(actionSheetItem?.name ?? "")"),
                            message: Text("What would you like to do?"),
                            buttons: [
                                .default(Text("Edit")) {
                                    if let item = actionSheetItem {
                                        selectedItem = item
                                    }
                                },
                                .destructive(Text("Delete")) {
                                    if let item = actionSheetItem {
                                        deleteItem(item)
                                    }
                                },
                                .cancel()
                            ])
            }
            .sheet(item: $selectedItem) { item in
                EditShoppingItemView(item: item) { updatedItem in
                    if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
                        items[index] = updatedItem
                    }
                    selectedItem = nil
                }
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
    
    private func deleteItem(_ item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
}

