//
//  ViewModifiers.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 13/06/2023.
//

import Foundation
import SwiftUI

extension View {
    func listSection() -> some View {
        modifier(ListSection())
    }
    func caption(text: String) -> some View {
        modifier(Caption(text: text))
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ListSection: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 18)
    }
}

struct Caption: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
