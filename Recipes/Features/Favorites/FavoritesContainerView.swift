//
//  FavoritesContainerView.swift
//  Recipes
 
import SwiftUI

struct FavoritesContainerView: View {
    @EnvironmentObject var store: AppStore

    private var favorites: [Recipe] {
        store.state.favorited.compactMap {
            store.state.allRecipes[$0]
        }
    }

    var body: some View {
        RecipesView(recipes: favorites)
            .navigationBarTitle("favorites")
    }
}
