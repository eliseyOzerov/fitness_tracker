//
//  FoodItemRow.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 11/06/2023.
//

import SwiftUI

struct FoodItemRow: View {
    let item: FoodItem
    
    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            AsyncImage(url: URL(string: item.thumbnailUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: 80, maxHeight: 80)
                    
            } placeholder: {
                Color.gray
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: 80, maxHeight: 80)
                    
            }
            .cornerRadius(12)
            .padding(.trailing)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.title ?? "")
                        .font(.headline)
                        .padding(.trailing, 12)
                    Spacer()
                }
                HStack {
                    StatView(title: "Calories", value: item.calories, small: true)
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 40)
                        .foregroundColor(.gray.opacity(0.5))
                        .cornerRadius(1)
                    Spacer()
                    StatView(title: "Protein", value: item.protein, unit: "g", small: true)
                    Spacer()
                    StatView(title: "Carbs", value: item.carbs, unit: "g", small: true)
                    Spacer()
                    StatView(title: "Fats", value: item.fats, unit: "g", small: true)
                }
            }
            .padding(.vertical, 8)
        }
        .padding()
    }
}

struct FoodItemRow_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemRow(item: .preview)
    }
}
