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
    @State var brand: String = ""
    @State var title: String = ""
    @State var notes: String = ""
    @State var calories: Int?
    @State var protein: Int?
    @State var carbs: Int?
    @State var fats: Int?
    
    @State var showScanner = false
    @State var code: String = ""
    
    @State var showImagePicker = false
    @State private var inputImage: UIImage?
    
    func save() {
        
    }
    
    func cancel() {
        
    }
    
    func scanBarcode() {
        
    }
    
    func addPhoto() {
        
    }
    
    var canSaveItem: Bool {
        !brand.isEmpty && !title.isEmpty && calories != nil && protein != nil && carbs != nil && fats != nil && !code.isEmpty
    }
    
    var body: some View {
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

                            Button(action: {
                                withAnimation(.easeInOut) {
                                    inputImage = nil
                                }
                            }) {
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
                VStack(alignment: .leading) {
                    Text("Notes")
                    TextField("e.g. Microwave for 5 minutes before eating", text: $notes,  axis: .vertical)
                        .lineLimit(0...5)
                }
            }
            Section("Nutrition (per 100g)") {
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
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: addPhoto) {
            ImagePicker(image: $inputImage, sourceType: .camera)
                .ignoresSafeArea()
        }
    }
}

struct CreateFoodView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFoodView()
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
