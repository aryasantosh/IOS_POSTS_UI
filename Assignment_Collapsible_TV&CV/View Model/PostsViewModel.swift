//
//  PostsViewModel.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//
// PostsViewModel.swift
//

import Foundation

class PostsViewModel {
    private let apiService = APIService()
    var posts: [Post] = []
    
    var topPosts: [Post] {
        Array(posts.prefix(10))
    }
    
    var remainingPosts: [Post] {
        Array(posts.dropFirst(10))
    }
    
    func setupNetworkMonitor(onPostsUpdated: (() -> Void)?, onError: ((String) -> Void)?, showToast: @escaping ((String)-> ())) {
        NetworkMonitor.shared.onNetworkStatusChanged = { [weak self] isConnected in
            print("Network status changed: \(isConnected ? "Connected" : "Disconnected")")
            
            if isConnected {
                self!.checkInternetAndFetchPosts(onPostsUpdated: onPostsUpdated, onError: onError)
                showToast(" Connected ")
            } else {
                self?.fetchFavoritePostsFromUserDefaults(onPostsUpdated: onPostsUpdated, onError: onError)
                showToast(" No Internet ")
            }
        }
    }
    
    func checkInternetAndFetchPosts(onPostsUpdated: (() -> Void)?, onError: ((String) -> Void)?) {
        if NetworkMonitor.shared.isConnected {
            apiService.fetchPosts { [weak self] result in
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.generateRandomTextMapping() // 🔹 Shuffle texts after fetching
                    onPostsUpdated?()
                    
                case .failure(let error):
                    self?.handleError(error, onError: onError)
                }
            }
        } else {
            self.fetchFavoritePostsFromUserDefaults(onPostsUpdated: onPostsUpdated, onError: onError)
        }
    }

    private func handleError(_ error: APIError, onError: ((String) -> Void)?) {
        var errorMessage: String
        switch error {
        case .invalidURL:
            errorMessage = "Invalid URL"
        case .networkError(let networkError):
            errorMessage = "Network error: \(networkError.localizedDescription)"
        case .noData:
            errorMessage = "No data available"
        case .serializationError(let serializationError):
            errorMessage = "Error parsing data: \(serializationError.localizedDescription)"
        }
        
        onError?(errorMessage)
    }

    func sortPostsByFavorites() {
        let collectionViewPosts = posts.prefix(10)
        var tableViewPosts = Array(posts.dropFirst(10))
        
        var favoritePosts: [Post] = []
        var nonFavoritePosts: [Post] = []
        
        for post in tableViewPosts {
            if post.isFavourite ?? false {
                favoritePosts.append(post)
            } else {
                nonFavoritePosts.append(post)
            }
        }
        
        nonFavoritePosts.sort { $0.id < $1.id }
        tableViewPosts = favoritePosts + nonFavoritePosts
        posts = Array(collectionViewPosts) + tableViewPosts
    }
    
    func updateFavoriteStatus(for id: Int, isFavorite: Bool) {
        for i in 0..<posts.count {
            if posts[i].id == id {
                posts[i].isFavourite = isFavorite
                break
            }
        }
        
        saveFavoritesToUserDefaults() // Ensure favorites are saved instantly
    }
    
    private func saveFavoritesToUserDefaults() {
        let favoritePosts = posts.filter { $0.isFavourite == true }
        UserDefaultsHelper.shared.saveFavoritePosts(favoritePosts)
        print("Saved to UserDefaults:", favoritePosts.map { "ID: \($0.id), Fav: \($0.isFavourite ?? false)" })
    }
    
    func fetchFavoritePostsFromUserDefaults(onPostsUpdated: (() -> Void)?, onError: ((String) -> Void)?) {
        let savedFavorites = UserDefaultsHelper.shared.fetchFavoritePosts()
        posts = savedFavorites
        onPostsUpdated?()
    }
    
    
    
    // 🔹 Stores a shuffled list of unique random texts
        private var randomTextsMapping: [Int: String] = [:]

        func generateRandomTextMapping() {
            let shuffledTexts = Constants.randomTexts.shuffled()
            
            for (index, post) in posts.enumerated() {
                if index < shuffledTexts.count {
                    randomTextsMapping[post.id] = shuffledTexts[index] // Assign shuffled text uniquely
                } else {
                    randomTextsMapping[post.id] = shuffledTexts[index % shuffledTexts.count]
                }
            }
        }

        func getRandomText(for postId: Int) -> String {
            return randomTextsMapping[postId] ?? "Default Text"
        }
}


