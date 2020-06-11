//
//  HomeContainerView.swift
//  Recipes
//
 
import SwiftUI

struct HomeContainerView: View {
    @EnvironmentObject var store: AppStore
    @State private var favoritesShown = false

    private var hasFavorites: Bool {
        !store.state.favorited.isEmpty
    }

    private var health: Binding<Health> {
        store.binding(for: \.health) { .setHealth(health: $0) }
    }

    var body: some View {
        HomeView(health: health)
            .onAppear { self.store.send(.resetState) }
            .navigationBarTitle("recipes")
            .navigationBarItems(
                trailing: hasFavorites ? Button(action: { self.favoritesShown = true }) {
                    Image(systemName: "heart.fill")
                        .font(.headline)
                        .accessibility(label: Text("favorites"))
                } : nil
        ).sheet(isPresented: $favoritesShown) {
                FavoritesContainerView()
                    .environmentObject(self.store)
                    .embedInNavigation()
                    .accentColor(.green)
        }
    }
}

struct HomeContainerView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}