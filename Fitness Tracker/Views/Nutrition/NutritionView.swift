//
//  NutritionView.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 01/05/2023.
//

import SwiftUI
import Charts
import CoreData

struct NutritionView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var selectedDay: Date = Date() {
        didSet {
            fetchItems()
        }
    }
    @State var isAddSheetPresented: Bool = false
    @State var caloriesGoal: Int?
    @State var proteinGoal: Int?
//    @State var ca
    
    @FetchRequest(sortDescriptors: [])
    var itemsfr: FetchedResults<LoggedFood>
    
    @State var items: [Date:[LoggedFood]] = [:]
    
    func fetchItems() {
        // fetching 3 weeks - current and both adjacent weeks
        let start = Date().startOfWeek().subtract(component: .day, value: 7)
        let end = start.add(component: .day, value: 14)
        let datePredicate = NSPredicate(format: "(date >= %@) AND (date < %@)", start as NSDate, end as NSDate)
        let fetchRequest: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        fetchRequest.predicate = datePredicate
        do {
            let allItems = try moc.fetch(fetchRequest)
//            items = Dictionary(grouping: allItems, by: { $0.dateTime!.startOfDay() })
        } catch {
            print(error)
        }
    }
    
    func fetchGoals() {
        caloriesGoal = UserDefaults.standard.integer(forKey: "caloriesGoal")
    }
    
    var week: [Int] {
        return selectedDay.currentWeek().map { $0.day }
    }
    
    /// info for each day:
    ///  protein kcal
    ///  carb kcal
    ///  fat kcal
    ///  goal kcal
    ///  goal protein
    ///  goal carbs
    ///  goal fats
    ///  spent kcal
    ///
    
    init() {
        fetchItems()
//        fetchGoals()
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    Spacer()
                        .frame(height: 10)
                    WeekPickerView(selected: $selectedDay, week: week)
                    Spacer()
                        .frame(height: 20)
                    TabView {
                        ForEach(itemsfr, id: \.self) { item in
                            Text(item.item!.title!)
                        }
//                        ForEach(items.sorted(by: { $0.key > $1.key }), id: \.self.key) { item in
//                            VStack {
//                                CaloriesView(proteinCalories: 400, carbCalories: 1300, fatCalories: 500, goalCalories: 2300, spentCalories: 320)
//                                Spacer()
//                                    .frame(height: 20)
//                                NutrientsView(protein: 400, proteinGoal: 480, carbs: 1300, carbGoal: 1200, fats: 414, fatGoal: 400)
//                                Spacer()
//                                    .frame(height: 20)
//                                LoggedFoodsView(items: item.value)
//                                Spacer()
//                            }
//                        }
                    }
                    .frame(height: geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .background(Color(UIColor.systemGroupedBackground))
                .sheet(isPresented: $isAddSheetPresented) {
                    LogFoodView(showSheet: $isAddSheetPresented)
                }
                .navigationTitle("Nutrition")
                .toolbar {
                    ToolbarItem {
                        Button {
                            isAddSheetPresented = true
                        } label: {
                            Image(systemName: "plus")
                        }

                    }
                }
            }
        }
    }
}

struct WeekPickerView: View {
    
    @Binding var selected: Date
    var week: [Int] = []
    
    func foregroundColor(day: Int) -> Color {
        if day == selected.day {
            return .white
        } else if Date().with(day: day)?.isInWeekend() ?? false {
            return .gray
        } else {
            return .black
        }
    }
    
    var body: some View {
        return HStack {
            ForEach(week, id: \.self) { day in
                VStack {
                    Text(Date.weekdaySymbols[week.firstIndex(of: day)!].uppercased().first!.description)
                        .font(.caption)
                        .foregroundColor(Date().with(day: day)?.isInWeekend() ?? false ? .gray : .black)
                    Text("\(day)")
                        .font(.subheadline)
                        .fontWeight(day == selected.day ? .bold : .regular)
                        .foregroundColor(foregroundColor(day: day))
                        .frame(width: 36, height: 36)
                        .background(day == selected.day ? Color.blue.opacity(1) : Color.blue.opacity(0))
                    .cornerRadius(20)
                }
                if day != week.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 18)
    }
}

//struct NutritionView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIViewController
//
//    @State var isAddSheetPresented = false
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let hc = UIHostingController(rootView: NutritionViewContent(isAddSheetPresented: $isAddSheetPresented))
//        let nc = UINavigationController(rootViewController: hc)
//        hc.view.backgroundColor = UIColor.systemGroupedBackground
//
//        hc.title = "Nutrition"
//        nc.navigationBar.prefersLargeTitles = true
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: context.coordinator, action: #selector(Coordinator.addButtonTapped))
//        hc.navigationItem.rightBarButtonItem = addButton
//
//        return nc
//    }
//
//    func updateUIViewController(_ nc: UIViewController, context: Context) {
//        // Update your view controller here
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, ObservableObject {
//        var parent: NutritionView
//
//        init(_ parent: NutritionView) {
//            self.parent = parent
//        }
//
//        @objc func addButtonTapped() {
//            parent.isAddSheetPresented = true
//        }
//    }
//}

struct CaloriesView: View {
        
    var proteinCalories: Double
    var carbCalories: Double
    var fatCalories: Double
    var goalCalories: Double
    var spentCalories: Double
    
    var totalConsumedCalories: Double {
        proteinCalories + carbCalories + fatCalories
    }
    
    var totalAvailableCalories: Double {
        goalCalories + spentCalories
    }
    
    var remainingCalories: Double {
        totalAvailableCalories - totalConsumedCalories
    }
    
    var macros: [(macro: String, data: Double)] {
        [
            (macro: "Protein", data: proteinCalories),
            (macro: "Carbs", data: carbCalories),
            (macro: "Fats", data: fatCalories)
        ]
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Calories")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(remainingCalories)) remaining")
                    .foregroundColor(.gray)
            }
            Chart {
                ForEach(macros, id: \.macro) { item in
                    BarMark(x: .value(item.macro, item.data))
                        .foregroundStyle(by: .value("Macro", item.macro))
                }
                RuleMark(x: .value("Goal", goalCalories), yStart: 0, yEnd: 40)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5,4]))
                    .foregroundStyle(.gray)
            }
            .chartLegend(position: .bottom, spacing: -15)
            .chartXScale(domain: 0...totalAvailableCalories)
            .chartPlotStyle {
                $0
                    .frame(height: 40)
                    .background(Color(UIColor.secondarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: goalCalories)) { value in
                    if value.as(Double.self) == goalCalories {
                        AxisTick(length: 20, stroke: StrokeStyle(lineWidth: 1, dash: [5,4]))
                            .foregroundStyle(.gray)
                        AxisValueLabel(anchor: .topTrailing) {
                            Text("\(Int(goalCalories)) kCal")
                                .font(.footnote)
                        }
                    }
                }
            }
        }
        .listSection()
    }
}

struct NutrientsView: View {
    
    var protein: Double
    var proteinGoal: Double
    var proteinPercentage: Double {
        protein / proteinGoal
    }
    
    var carbs: Double
    var carbGoal: Double
    var carbPercentage: Double {
        carbs / carbGoal
    }
    
    var fats: Double
    var fatGoal: Double
    var fatPercentage: Double {
        fats / fatGoal
    }
    
    func showAllNutrients() {
        // TODO: implement
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Nutrients")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button("View all") {
                    showAllNutrients()
                }
            }
            HStack(spacing: 20) {
                CustomProgressView(proteinPercentage, color: .blue) {
                    StatView(title: "Protein", value: protein / 4, unit: "g")
                }
                CustomProgressView(carbPercentage, color: .green) {
                    StatView(title: "Carbs", value: carbs / 4, unit: "g")
                }
                CustomProgressView(fatPercentage, color: .orange) {
                    StatView(title: "Fats", value: fats / 9, unit: "g")
                }
            }
        }
        .listSection()
    }
}

struct LoggedFoodsView: View {
    
    var items: [LoggedFood] = []
    
    func showAllNutrients() {
        // TODO: implement
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("Logged food")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button("View all") {
                    showAllNutrients()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
            ForEach(items) { item in
                HStack(spacing: .zero) {
                    AsyncImage(url: URL(string: item.item?.thumbnailUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(maxWidth: 50, maxHeight: 50)

                    } placeholder: {
                        Color.gray
                            .aspectRatio(1, contentMode: .fill)
                            .frame(maxWidth: 50, maxHeight: 50)

                    }
                    .cornerRadius(8)
                    .padding(.trailing)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(item.item!.title!)")
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(item.dateTime!.formatted(date: .omitted, time: .shortened))")
                            Text("⋅")
                            Text("\(Int(item.amount))g")
                        }
                        .font(Font.footnote)
                        .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("kCal")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(Int(item.item!.calories * item.amount / 100))")
                    }
                }
                .padding(.horizontal, 20)
                if item != items.last {
                    Divider()
                        .padding(.leading, 20)
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(.vertical, 10)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 20)
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
    var value: Double
    var unit: String?
    var small: Bool = false
    var bold: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(Int(value))\(unit ?? "")")
                .font(small ? .body : .title3)
                .fontWeight(bold ? .semibold : .regular)
        }
    }
}

//struct CaloriesView: View {
//    var goal: Double
//    var consumed: Double
//    var spent: Double
//    var left: Double {
////        Double(goal - consumed + spent)
//        0
//    }
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("CALORIES")
//                .font(.footnote)
//                .foregroundColor(.gray)
//                .fontWeight(.medium)
//            HStack {
//                Group{
//                    StatView(title: "Left", value: left)
//                        .foregroundColor(.green)
//                    Spacer()
//                    Text("=")
//                        .font(.title3)
//                    Spacer()
//                    StatView(title: "Goal", value: goal)
//                    Spacer()
//                    Text("-")
//                        .font(.title3)
//                    Spacer()
//                    StatView(title: "Consumed", value: consumed)
//                }
//                Group {
//                    Spacer()
//                    Text("+")
//                        .font(.title3)
//                    Spacer()
//                    StatView(title: "Spent", value: spent)
//                }
//            }
//            .padding()
//            .cornerRadius(12)
//            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.4)))
//        }
//        .padding(.horizontal)
//    }
//}

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

struct CustomProgressView<Content: View>: View {
    let content: Content

    init(_ progress: Double, color: Color? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.progress = progress
        if let color = color {
            self.progressColor = color
        }
    }

    var progress: Double
    var trackColor: Color = Color.gray.opacity(0.2)
    var progressColor: Color = Color.blue
    var lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 3/4)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(trackColor)
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: min(CGFloat(progress) * 3/4, 0.75))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(progressColor)
                .rotationEffect(.degrees(135))
            
            content
        }
        .padding(lineWidth/2)
        .frame(maxWidth: .infinity)
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = Persistence(inMemory: true)
        NutritionView()
            .environment(\.managedObjectContext, persistence.container.viewContext)
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
