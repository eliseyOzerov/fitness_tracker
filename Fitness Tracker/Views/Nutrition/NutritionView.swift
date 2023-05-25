//
//  NutritionView.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 01/05/2023.
//

import SwiftUI

struct NutritionView: View {
    @State var selectedDay: Date = Date()
    @State var isAddSheetPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    DayChangerView(day: $selectedDay)
                    CaloriesView(goal: 2000, consumed: 1500, spent: 300)
                        .padding(.bottom)
                    MacrosView()
                        .padding(.bottom)
                    FoodListView()
                        .padding(.bottom)
                }
                .navigationTitle("Nutrition")
                .toolbar {
                    Button {
                        isAddSheetPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .sheet(isPresented: $isAddSheetPresented) {
                AddFoodView(showSheet: $isAddSheetPresented)
            }
        }
    }
}

struct DayChangerView: View {
    @Binding var day: Date
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .fontWeight(.medium)
                .font(.system(size: 20))
                .padding()
                .onTapGesture {
                    day.addTimeInterval(-86400)
                }
            Spacer()
            Text(formattedDate(date: day))
            Spacer()
            Image(systemName: "chevron.right")
                .fontWeight(.medium)
                .font(.system(size: 20))
                .foregroundColor(.blue.opacity(Calendar.current.isDateInToday(day) ? 0.5 : 1))
                .padding()
                .onTapGesture {
                    if (Calendar.current.isDateInToday(day)) {
                        return
                    }
                    day.addTimeInterval(86400)
                }
        }
        .foregroundColor(.blue)
        .padding(.horizontal)
        
    }
}

struct StatView: View {
    var title: String
    var value: Int
    var unit: String?
    var small: Bool = false
    var bold: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(value)\(unit ?? "")")
                .font(small ? .body : .title3)
                .fontWeight(bold ? .semibold : .regular)
        }
    }
}

struct CaloriesView: View {
    var goal: Int
    var consumed: Int
    var spent: Int
    var left: Int {
        goal - consumed + spent
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("CALORIES")
                .font(.footnote)
                .foregroundColor(.gray)
                .fontWeight(.medium)
            HStack {
                Group{
                    StatView(title: "Left", value: left)
                        .foregroundColor(.green)
                    Spacer()
                    Text("=")
                        .font(.title3)
                    Spacer()
                    StatView(title: "Goal", value: goal)
                    Spacer()
                    Text("-")
                        .font(.title3)
                    Spacer()
                    StatView(title: "Consumed", value: consumed)
                }
                Group {
                    Spacer()
                    Text("+")
                        .font(.title3)
                    Spacer()
                    StatView(title: "Spent", value: spent)
                }
            }
            .padding()
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.4)))
        }
        .padding(.horizontal)
    }
}

struct MacrosView: View {
    @State private var progress: Double = 0.6
    var body: some View {
        VStack(alignment: .leading) {
            Text("MACROS")
                .font(.footnote)
                .foregroundColor(.gray)
                .fontWeight(.medium)
            HStack(spacing: 20) {
                CustomProgressView(progress) {
                    StatView(title: "Protein", value: 120, unit: "g")
                }
                CustomProgressView(progress) {
                    StatView(title: "Carbs", value: 230, unit: "g")
                }
                CustomProgressView(progress) {
                    StatView(title: "Fats", value: 40, unit: "g")
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

struct FoodListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("FOODS")
                .font(.footnote)
                .foregroundColor(.gray)
                .fontWeight(.medium)
            VStack(spacing: .zero) {
                FoodView()
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.gray.opacity(0.2))
                    .padding(.leading)
                FoodView()
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.gray.opacity(0.2))
                    .padding(.leading)
                FoodView()
            }
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.4)))
        }
        .padding(.horizontal)
    }
}

struct FoodView: View {
    let url = URL(string: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80")
    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: 80)
                    
            } placeholder: {
                Color.gray
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: 80)
                    
            }
            .cornerRadius(12)
            .padding(.trailing)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Greek Salad")
                        .font(.headline)
                        .padding(.trailing, 12)
                    Spacer()
                    Text("RECIPE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.8))
                        .cornerRadius(4)
                }
                HStack {
                    StatView(title: "Calories", value: 450, small: true)
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 40)
                        .foregroundColor(.gray.opacity(0.5))
                        .cornerRadius(1)
                    Spacer()
                    StatView(title: "Protein", value: 40, unit: "g", small: true)
                    Spacer()
                    StatView(title: "Carbs", value: 180, unit: "g", small: true)
                    Spacer()
                    StatView(title: "Fats", value: 18, unit: "g", small: true)
                }
            }
            .padding(.vertical, 8)
        }
        .padding()
    }
}

struct CustomProgressView<Content: View>: View {
    let content: Content

    init(_ progress: Double, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.progress = progress
    }

    var progress: Double
    var trackColor: Color = Color.gray.opacity(0.2)
    var progressColor: Color = Color.blue
    var lineWidth: CGFloat = 6

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 3/4)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(trackColor)
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: CGFloat(progress) * 3/4)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(progressColor)
                .rotationEffect(.degrees(135))
            
            content
        }
        .padding(lineWidth/2)
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}

func formattedDate(date: Date) -> String {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
    let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: today)!
    let oneWeekAhead = calendar.date(byAdding: .weekOfYear, value: 1, to: today)!

    let dateFormatter = DateFormatter()

    if calendar.isDate(date, inSameDayAs: today) {
        return "Today"
    } else if calendar.isDate(date, inSameDayAs: yesterday) {
        return "Yesterday"
    } else if calendar.isDate(date, inSameDayAs: tomorrow) {
        return "Tomorrow"
    } else if date < oneWeekAgo || date > oneWeekAhead {
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    } else {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}
