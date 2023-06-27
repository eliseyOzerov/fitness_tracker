//
//  AddFoodView.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 04/05/2023.
//

import SwiftUI
import CoreData

struct LogFoodView: View {
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    @Binding var showSheet: Bool
    
    @State var showScanner = false
    @State var showCreateFoodView = false
    
    @State var barcode = ""
    @State var showCancelActions = false
    
    @FetchRequest(sortDescriptors: [])
    private var items: FetchedResults<FoodItem>
    
    func confirm() {
        
    }
    
    func cancel() {
        if (selectedItems.isEmpty) {
            showSheet = false
        } else {
            showCancelActions = true
        }
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
    @State var selectedItems: [FoodItem] = []
    
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
                Button {
                    showCreateFoodView = true
                } label: {
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
                        List {
                            Group {
                                if (!selectedItems.isEmpty) {
                                    Section("Selected") {
                                        ForEach(selectedItems, id: \.objectID) { item in
                                            Text(item.title ?? "")
                                                .onTapGesture {
                                                    selectedItems.remove(at: selectedItems.index(of: item)!)
                                                }
                                        }
                                    }
                                }
                            }
                            Section("All Items") {
                                ForEach(items, id: \.objectID) { item in
                                    Text(item.title ?? "")
                                        .onTapGesture {
                                            selectedItems.append(item)
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
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
            .confirmationDialog("Cancel logging food?", isPresented: $showCancelActions) {
                Button(role: .destructive) {
                    showSheet = false
                } label: {
                    Text("Cancel")
                }
                Button() {
                    showCancelActions = false
                } label: {
                    Text("Continue")
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
                CreateFoodView(isScreenPresented: $showCreateFoodView, code: barcode)
            }
        }
    }
}

struct LogFoodView_Previews: PreviewProvider {
    static var persistence = Persistence()
    
    static var previews: some View {
        LogFoodView(showSheet: .constant(false))
            .environment(\.managedObjectContext, persistence.container.viewContext)
    }
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
            Text(item.title!)
            HStack {
                StatView(title: "Calories", value: item.calories, small: true)
                Spacer()
                Rectangle()
                    .frame(width: 1, height: 32)
                    .foregroundColor(.gray.opacity(0.5))
                    .cornerRadius(1)
                Spacer()
                StatView(title: "Protein", value: item.protein, unit: "g", small: true)
                Spacer()
                StatView(title: "Carbs", value: item.carbs, unit: "g", small: true)
                Spacer()
                StatView(title: "Fats", value: item.fats, unit: "g", small: true)
            }
            .padding(.horizontal, 12)
        }
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
