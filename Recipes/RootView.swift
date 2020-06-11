//
//  ContentView.swift
//  Recipes
//


import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            HomeContainerView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
