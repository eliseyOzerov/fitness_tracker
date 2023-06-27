//
//  CreateFoodView.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 17/05/2023.
//

import SwiftUI
import AVFoundation
import VisionKit



struct CreateFoodView: View {
    @Environment(\.managedObjectContext) var persistence
    
    @State var brand: String = ""
    @State var title: String = ""
    @State var notes: String = ""
    @State var calories: Int?
    @State var protein: Double?
    @State var carbs: Double?
    @State var fats: Double?
    @State var category: String = "None"
    
    @Binding var isScreenPresented: Bool
    
    @State var showScanner = false
    @State var code: String = ""
    
    @State var showImagePicker = false
    @State var inputImage: UIImage?
    
    let categories = [
        "None",
        "Fruits & Vegetables",
        "Meat & Seafood",
        "Meat Alternatives",
        "Dairy & Eggs",
        "Dairy Alternatives",
        "Specialty Cheeses",
        "Bread & Bakery",
        "Bakery & Dessert Items",
        "Pasta & Rice",
        "Cereal & Breakfast Foods",
        "Snacks",
        "Beverages",
        "Non-alcoholic Beverages",
        "Beer, Wine, & Spirits",
        "Ice & Beverage Mixes",
        "Condiments & Sauces",
        "Spices & Seasonings",
        "Baking Ingredients",
        "Canned Goods & Soups",
        "Frozen Foods",
        "Deli & Prepared Foods",
        "International Foods",
        "Health Foods",
        "Baby & Child Products",
        "Bulk Items",
    ]
    
    func save() {
        let item = FoodItem(context: persistence)
        item.barcode = code
        item.brand = brand
        item.title = title
        item.notes = notes
        item.protein = protein!
        item.carbs = carbs!
        item.fats = fats!
        item.category = category
        item.thumbnailUrl = savePhoto()
        do {
            try persistence.save()
            isScreenPresented = false
        } catch {
            print(error)
        }
    }
    
    func savePhoto() -> String? {
        guard let data = inputImage?.pngData() else { return nil }
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let completeUrl = url.appendingPathComponent("\(code)-\(title).png")
        
        do {
            try data.write(to: completeUrl)
        } catch {
            print("Something went wrong while saving photo \(error)")
            return nil
        }
        
        let res = completeUrl.absoluteString
        
        print("Saved the photo to \(res)")
        
        return res
    }
    
    var canSaveItem: Bool {
        !brand.isEmpty && !title.isEmpty && calories != nil && protein != nil && carbs != nil && fats != nil && !code.isEmpty
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Barcode")
                        TextField("e.g. 12345678", text: $code)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Rectangle()
                            .frame(maxWidth: 2, maxHeight: 24)
                            .foregroundColor(Color(UIColor.systemGray3.cgColor))
                            .padding(.horizontal, 4)
                        Button {
                            showScanner = true
                        } label: {
                            Image(systemName: "barcode.viewfinder")
                                .font(.title)
                        }
                    }
                } header: {
                    Button {
                        showImagePicker = true
                    } label: {
                        if let image = inputImage {
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                Button {
                                    withAnimation(.easeInOut) {
                                        inputImage = nil
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(SymbolRenderingMode.multicolor)
                                        .font(.system(size: 32))
                                }
                                .offset(x: sin(45)*100-15, y: -sin(45)*100+15)
                            }
                        } else {
                            VStack {
                                Image(systemName: "camera")
                                    .font(.system(size: 32))
                                    .padding(.bottom, 8)
                                Text("Add photo")
                            }
                            .frame(width: 200, height: 200)
                            .background(RoundedRectangle(cornerRadius: 100).stroke(.blue, lineWidth: 2))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(18)
                    .padding(.bottom, 20)
                }
                Section("General") {
                    HStack {
                        Text("Brand")
                        TextField("e.g. Barilla", text: $brand)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Title")
                        TextField("e.g. Spaghettoni N.8", text: $title)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { item in
                            Text(item)
                                .foregroundColor(item == "None" ? Color(UIColor.tertiaryLabel) : .black)
                        }
                    }
                    .pickerStyle(NavigationLinkPickerStyle())
                    VStack(alignment: .leading) {
                        Text("Notes")
                        TextField("e.g. Microwave for 5 minutes before eating", text: $notes,  axis: .vertical)
                            .lineLimit(0...5)
                    }
                }
                Section("Macronutrients (per 100g)") {
                    HStack(spacing: 4) {
                        Text("Calories")
                        TextField("243", value: $calories, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("kcal")
                            .foregroundColor(calories != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                    }
                    HStack(spacing: 4) {
                        Text("Protein")
                        TextField("23", value: $protein, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                            .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                    }
                    HStack(spacing: 4) {
                        Text("Carbs")
                        TextField("130", value: $carbs, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                            .foregroundColor(carbs != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                    }
                    HStack(spacing: 4) {
                        Text("Fats")
                        TextField("5", value: $fats, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                            .foregroundColor(fats != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                    }
                }
                Section("Vitamins (per 100g)") {
                    Group {
                        HStack(spacing: 4) {
                            Text("Vitamin A")
                            TextField("0.9", value: $calories, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(calories != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin B1")
                            TextField("1.2", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin B2")
                            TextField("1.3", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin B3")
                            TextField("16", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin B5")
                            TextField("5", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                    }
                    Group {
                        HStack(spacing: 4) {
                            Text("Vitamin B7")
                            TextField("1.7", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin B9")
                            TextField("0.4", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin B12")
                            TextField("0.0024", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin C")
                            TextField("90", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin D")
                            TextField("0.02", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin E")
                            TextField("0.015", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Vitamin K")
                            TextField("0.12", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                    }
                }
                Section("Minerals (per 100g)") {
                    Group {
                        HStack(spacing: 4) {
                            Text("Calcium")
                            TextField("1000", value: $calories, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(calories != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Iron")
                            TextField("18", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Magnesium")
                            TextField("400", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Phosphorus")
                            TextField("1000", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Potassium")
                            TextField("4700", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                    }
                    Group {
                        HStack(spacing: 4) {
                            Text("Sodium")
                            TextField("1500", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Zinc")
                            TextField("11", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Copper")
                            TextField("0.9", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Manganese")
                            TextField("2.3", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Selenium")
                            TextField("0.055", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Fluoride")
                            TextField("4", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Chromium")
                            TextField("0.035", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Molybdenum")
                            TextField("0.045", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                        HStack(spacing: 4) {
                            Text("Iodine")
                            TextField("0.15", value: $protein, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("mg")
                                .foregroundColor(protein != nil ? .primary : Color(UIColor.systemGray3.cgColor))
                        }
                    }
                }
            }
        }
        .navigationTitle("Create New Food")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("Save") {
                    save()
                }
                .disabled(!canSaveItem)
            }
        }
        .fullScreenCover(isPresented: $showScanner) {
            BarcodeScannerView { code in
                print(code)
                showScanner = false
            } onCancel: {
                showScanner = false
            }
            .ignoresSafeArea()
            .statusBarHidden()
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage, sourceType: .camera)
                .ignoresSafeArea()
        }
    }
}

struct CreateFoodView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFoodView(isScreenPresented: .constant(true))
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
