import SwiftUI

struct CartView: View {
    var items: [ShoppingItem]
    
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
            List(unpurchasedItems) { item in
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

            Spacer()
        }
        .padding()
        .navigationBarTitle("Cart", displayMode: .inline)
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(items: [
            ShoppingItem(name: "Pork (2)", price: "$76.00 (2 x $38.00)", category: "Meats", purchased: false),
            ShoppingItem(name: "Cucumbers", price: "$5.00", category: "Vegetable", purchased: false),
            ShoppingItem(name: "Rice", price: "$10.00", category: "Pasta, Rice & Cereals", purchased: false)
        ])
    }
}

