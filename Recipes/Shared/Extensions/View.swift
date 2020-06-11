//
//  View.swift
//  Recipes
//
 
import SwiftUI

extension View {
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
