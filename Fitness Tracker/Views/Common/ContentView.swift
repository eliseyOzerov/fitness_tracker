//
//  ContentView.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 01/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                NutritionView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "fork.knife")
                        Text("Nutrition")
                    }
                TrainingView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "dumbbell")
                        Text("Training")
                    }
                BodyView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "figure.stand")
                        Text("Body")
                    }
                SettingsView()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
