//
//  AddFoodView.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 04/05/2023.
//

import SwiftUI

struct AddFoodView: View {
    @Binding var showSheet: Bool
    @State var items: [FoodItem] = []
    @State var showScanner = false
    @State var showCreateFoodView = false
    @State var barcode = ""
    
    func confirm() {
        
    }
    
    func cancel() {
        showSheet = false
    }
    
    func scanBarcode() {
        
    }
    
    func addRecipe() {
        
    }
    
    func addMeal() {
        
    }
    
    func addItem() {
        
    }
    
    func mealFromSelected() {
        
    }
    
    @State var searchText: String = ""
    @State var selectedItems: [String] = []
    
    let foodItem: FoodItem = FoodItem(
        id: 0,
        imageUrl: URL(string: "https://google.com")!,
        title: "🍳 Omelette",
        nutrition: NutritionInfo(
            calories: 200,
            protein: 20,
            carbohydrates: 80,
            fats: 5
        )
    )
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    SearchBar(text: $searchText)
                    Button {
                        showScanner = true
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .font(.title)
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing)
                NavigationLink(destination: CreateFoodView()) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                        Text("New item")
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(width: .infinity, height: 32)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(.blue))
                }
                .padding(.horizontal, 18)
                Group {
                    if (items.isEmpty) {
                        Spacer()
                        Text("Looks like there's nothing here, add some items!")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 80)
                        Spacer()
                    } else {
                        List(items) { item in
                            Text(item.title)
                        }
                    }
                }
//                    HStack(spacing: .zero) {
//                        Button {
//                            addItem()
//                        } label: {
//                            HStack {
//                                Image(systemName: "plus")
//                                Text("Item")
//                            }
//                            .padding(.horizontal)
//                            .frame(width: .infinity, height: 32)
//                            .background(RoundedRectangle(cornerRadius: 8).stroke(.blue))
//                        }
//                        .padding(.trailing)
//                        Button {
//                            addRecipe()
//                        } label: {
//                            HStack {
//                                Image(systemName: "plus")
//                                Text("Recipe")
//                            }
//                            .padding(.horizontal)
//                            .frame(width: .infinity, height: 32)
//                            .background(RoundedRectangle(cornerRadius: 8).stroke(.blue))
//                        }
//                        .padding(.trailing)
//                        Button {
//                            addMeal()
//                        } label: {
//                            HStack {
//                                Image(systemName: "plus")
//                                Text("Meal")
//                            }
//                            .padding(.horizontal)
//                            .frame(width: .infinity, height: 32)
//                            .background(RoundedRectangle(cornerRadius: 8).stroke(.blue))
//                        }
//                        Spacer()
//                    }
//                    .padding(.horizontal, 18)
//                    .padding(.bottom)
//                    ScrollView {
//                        VStack {
//                            Group {
//                                if (!selectedItems.isEmpty || true) {
//                                    CategoryView(
//                                        title: "Selected",
//                                        items: [foodItem]
//                                    )
//                                }
//                            }
//                            CategoryView(
//                                title: "Eating Now",
//                                items: [foodItem,foodItem,foodItem]
//                            )
//                            CategoryView(
//                                title: "Favorites",
//                                items: [foodItem,foodItem,foodItem,foodItem]
//                            )
//                            CategoryView(
//                                title: "Recipes",
//                                items: [foodItem,foodItem,foodItem,foodItem]
//                            )
//                            CategoryView(
//                                title: "Meals",
//                                items: [foodItem,foodItem,foodItem,foodItem]
//                            )
//                            CategoryView(
//                                title: "Drinks",
//                                items: [foodItem,foodItem,foodItem,foodItem]
//                            )
//                            CategoryView(
//                                title: "Desserts",
//                                items: [foodItem,foodItem,foodItem,foodItem]
//                            )
//                        }
//                    }
            }
            .navigationTitle("Log food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        confirm()
                    } label: {
                        Text("Confirm")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        cancel()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
            .fullScreenCover(isPresented: $showScanner) {
                BarcodeScannerView { code in
                    self.barcode = code
                    showCreateFoodView = true
                    showScanner = false
                } onCancel: {
                    showScanner = false
                }
                .ignoresSafeArea()
                .statusBarHidden()
            }
            .navigationDestination(isPresented: $showCreateFoodView) {
                CreateFoodView(code: barcode)
            }
        }
    }
}

struct FoodItem: Identifiable {
    
    var id: Int
    
    var imageUrl: URL
    var title: String
    var nutrition: NutritionInfo
}

struct NutritionInfo {
    var calories: Int
    var protein: Int
    var carbohydrates: Int
    var fats: Int
}

struct CategoryView: View {
    var title: String
    var items: [FoodItem]
    
    func seeAll() {
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title3)
                .fontWeight(.bold)
                Spacer()
                Group {
                    if (items.count > 3) {
                        Button("See all") {
                            seeAll()
                        }
                    }
                }
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items.prefix(3)) { item in
                        FoodItemCard(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
}

struct FoodItemCard: View {
    var item: FoodItem
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .frame(width: 240, height: 160)
                .cornerRadius(12)
                Text("No Image")
                    .font(.caption)
                    .opacity(0.5)
            }
            Text(item.title)
            HStack {
                StatView(title: "Calories", value: item.nutrition.calories, small: true)
                Spacer()
                Rectangle()
                    .frame(width: 1, height: 32)
                    .foregroundColor(.gray.opacity(0.5))
                    .cornerRadius(1)
                Spacer()
                StatView(title: "Protein", value: item.nutrition.protein, unit: "g", small: true)
                Spacer()
                StatView(title: "Carbs", value: item.nutrition.carbohydrates, unit: "g", small: true)
                Spacer()
                StatView(title: "Fats", value: item.nutrition.fats, unit: "g", small: true)
            }
            .padding(.horizontal, 12)
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView(showSheet: .constant(false))
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar
        
        init(_ searchBar: SearchBar) {
            self.parent = searchBar
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
    }
}
