//
//  App.swift
//  Recipes
//
 
import Combine
import Foundation

// For more information check "How To Control The World" - Stephen Celis
// https://vimeo.com/291588126
final class World {
    let session = URLSession.shared
    let counter = LaunchCounter()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let files = FileManager.default

    lazy var service: RecipesService =
        RecipesServiceLive(session: session, decoder: decoder)
}

struct AppState: Codable, Equatable {
    var allRecipes: [String: Recipe] = [:]
    var recipes: [String] = []
    var favorited: [String] = []
    var health: Health = .gluten
}

enum AppAction {
    case append(recipes: [Recipe])
    case saveToFavorites(recipe: Recipe)
    case removeFromFavorites(recipe: Recipe)
    case setHealth(health: Health)
    case search(query: String, page: Int = 0)
    case set(state: AppState)
    case resetState
    case load
    case save
}

func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: World
) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case let .append(recipes):
        recipes.forEach { state.allRecipes[$0.uri] = $0 }
        state.recipes = recipes.map { $0.uri }
    case let .saveToFavorites(recipe):
        state.favorited.append(recipe.uri)
    case let .removeFromFavorites(recipe):
        state.favorited.removeAll { $0 == recipe.uri }
    case .resetState:
        state.recipes.removeAll()
        state.allRecipes = state.allRecipes.filter { key, _ in
            state.favorited.contains(key)
        }
    case .setHealth(let health):
        state.health = health
        state.recipes.removeAll()
    case let .search(query, page):
        return environment.service
            .fetch(matching: query, in: state.health, page: page)
            .replaceError(with: [])
            .map { .append(recipes: $0)}
            .eraseToAnyPublisher()
    case let .set(newState):
        state = newState
    case .load:
        return environment.files
            .read(name: "state.json", in: .applicationSupportDirectory)
            .decode(type: AppState.self, decoder: environment.decoder)
            .replaceError(with: AppState())
            .map { AppAction.set(state: $0) }
            .eraseToAnyPublisher()
    case .save:
        return Just(state)
            .encode(encoder: environment.encoder)
            .flatMap { environment.files.write(data: $0, name: "state.json", in: .applicationSupportDirectory) }
            .map { _ in AppAction.resetState }
            .replaceError(with: .resetState)
            .eraseToAnyPublisher()
    }

    return Empty().eraseToAnyPublisher()
}

typealias AppStore = Store<AppState, AppAction, World>
