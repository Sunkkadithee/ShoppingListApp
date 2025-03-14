import SwiftUI
import CoreData
struct ShoppingListDetailView: View {
    var shoppingList: ShoppingList
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var items: FetchedResults<ShoppingItem>
    
    @State private var showAddItemModal: Bool = false
    @State private var refreshData: Bool = false
    @State private var actionSheetItem: ShoppingItem? // To store the selected item for action sheet
    @State private var showActionSheet: Bool = false // To trigger the display of the action sheet
    @State private var showEditItemModal: Bool = false // New state variable to show the edit view
    
    var groupedItems: [String: [ShoppingItem]] {
        Dictionary(grouping: items, by: { $0.category ?? "Uncategorized" })
    }
    
    func addItemsFromAddItemView(selectedItems: Set<String>) {
        for itemName in selectedItems {
            let newItem = ShoppingItem(context: viewContext)
            newItem.id = UUID()
            newItem.name = itemName
            newItem.shoppingList = shoppingList
            newItem.purchased = false
        }
        
        do {
            try viewContext.save()
            refreshData.toggle()
        } catch {
            print("Error saving items: \(error.localizedDescription)")
        }
    }
    
    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
        _items = FetchRequest(
            entity: ShoppingItem.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.name, ascending: true)],
            predicate: NSPredicate(format: "shoppingList == %@", shoppingList)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color(red: 11/255, green: 61/255, blue: 145/255)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 200)
                    
                    VStack {
                        Text("Welcome to \(shoppingList.name ?? "Unnamed") List")
                            .font(.title)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showAddItemModal = true
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
                }
                
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
                                        Button(action: {
                                            togglePurchased(for: item)
                                        }) {
                                            Image(systemName: item.purchased ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(item.purchased ? .blue : .gray)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.name ?? "Unnamed Item")
                                                .strikethrough(item.purchased)
                                                .foregroundColor(item.purchased ? .gray : .black)
                                            
                                            Text("$" + (item.price ?? "Price not available"))
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            actionSheetItem = item
                                            showActionSheet.toggle()
                                        }) {
                                            Image(systemName: "ellipsis")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(30)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.top, 20)
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Item Options"),
                    message: Text("What would you like to do with \(actionSheetItem?.name ?? "this item")?"),
                    buttons: [
                        .default(Text("Edit")) {
                            // Show the Edit Item modal
                            showEditItemModal = true
                        },
                        .destructive(Text("Delete")) {
                            if let item = actionSheetItem {
                                viewContext.delete(item)
                                try? viewContext.save()
                            }
                        },
                        .cancel()
                    ]
                )
            }
        }
        .sheet(isPresented: $showAddItemModal) {
            AddItemView(onDone: { selectedItems in
                addItemsFromAddItemView(selectedItems: selectedItems)
                showAddItemModal = false
            })
        }
        .sheet(isPresented: $showEditItemModal) {
            if let item = actionSheetItem {
                EditShoppingItemView(item: item) { updatedItem in
                    // Handle saving of updated item
                    // You may perform additional actions or UI updates
                    try? viewContext.save()
                    showEditItemModal = false
                }
            }
        }
    }
    
    private func togglePurchased(for item: ShoppingItem) {
        item.purchased.toggle()
        try? viewContext.save()
    }
}
