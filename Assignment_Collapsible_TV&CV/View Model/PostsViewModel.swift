//
//  PostsViewModel.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//
// PostsViewModel.swift

import Foundation

class PostsViewModel {
    private let apiService = APIService()
    var posts: [Post] = []
    var comments: [Comment] = []
    private(set) var filteredPosts: [Post] = [] 
    
    var topPosts: [Post] {
        Array(posts.prefix(10))
    }
    
    var remainingPosts: [Post] {
        Array(posts.dropFirst(10))
    }
    
    var onPostsUpdated: (() -> Void)?
    var onCommentsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchPosts() {
//        if NetworkMonitor.shared.isConnected {
            apiService.fetchPosts { [weak self] result in
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.filteredPosts = posts
                    self?.onPostsUpdated?()
                case .failure(let error):
                    self?.handleError(error)
                }
            }
//        } else {
//            filteredPosts = posts.filter { $0.isFavourite == true }
//            onPostsUpdated?()
//        }
    }
    func fetchComments(for postId: Int) {
        apiService.fetchComments(for: postId) { [weak self] result in
            switch result {
            case .success(let comments):
                self?.comments = comments
                self?.onCommentsUpdated?()
            case .failure(let error):
                self?.handleError(error) // Call the common error handling function
            }
        }
    }
    
    // Common error handling
    private func handleError(_ error: APIError) {
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
        
        // Handle error with custom communication method..
        onError?(errorMessage)
    }
    
//

    func sortPostsByFavorites() {
        // Split the posts into two parts: the first 10 posts and the rest
        let collectionViewPosts = posts.prefix(10) // Keep the first 10
        var tableViewPosts = Array(posts.dropFirst(10)) // Posts from 11th onward
        
        // Sort only the table view posts (11th onward)
        var favoritePosts: [Post] = []
        var nonFavoritePosts: [Post] = []
        
        for post in tableViewPosts {
            if post.isFavourite ?? false {
                favoritePosts.append(post)
            } else {
                nonFavoritePosts.append(post)
            }
        }
        
        nonFavoritePosts.sort{ $0.id < $1.id }

    
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
    }
    func showOnlyFavorites() {
//         Offline: Show only favorite posts
        filteredPosts = posts.filter { $0.isFavourite == true }
        onPostsUpdated?()
    }

}





//import Foundation
//
//class PostsViewModel {
//    private let apiService = APIService()
//    var posts: [Post] = [] // Assuming this is where the posts are stored
//    var comments: [Comment] = []
//    
//    var topPosts: [Post] {
//        Array(posts.prefix(10))
//    }
//    
//    var remainingPosts: [Post] {
//        Array(posts.dropFirst(10))
//    }
//    
//    var onPostsUpdated: (() -> Void)?
//    var onCommentsUpdated: (() -> Void)?
//    var onError: ((String) -> Void)?
//    
//    func fetchPosts() {
//        apiService.fetchPosts { [weak self] result in
//            switch result {
//            case .success(let posts):
//                self?.posts = posts
//                self?.onPostsUpdated?()
//            case .failure(let error):
//                self?.handleError(error) // Call the common error handling function
//            }
//        }
//    }
//    
//    func fetchComments(for postId: Int) {
//        apiService.fetchComments(for: postId) { [weak self] result in
//            switch result {
//            case .success(let comments):
//                self?.comments = comments
//                self?.onCommentsUpdated?()
//            case .failure(let error):
//                self?.handleError(error) // Call the common error handling function
//            }
//        }
//    }
//    
//    // Common error handling
//    private func handleError(_ error: APIError) {
//        var errorMessage: String
//        switch error {
//        case .invalidURL:
//            errorMessage = "Invalid URL"
//        case .networkError(let networkError):
//            errorMessage = "Network error: \(networkError.localizedDescription)"
//        case .noData:
//            errorMessage = "No data available"
//        case .serializationError(let serializationError):
//            errorMessage = "Error parsing data: \(serializationError.localizedDescription)"
//        }
//        
//        // Handle error with custom communication method..
//        onError?(errorMessage)
//    }
//    
////
//
//    func sortPostsByFavorites() {
//        // Split the posts into two parts: the first 10 posts and the rest
//        let collectionViewPosts = posts.prefix(10) // Keep the first 10
//        var tableViewPosts = Array(posts.dropFirst(10)) // Posts from 11th onward
//        
//        // Sort only the table view posts (11th onward)
//        var favoritePosts: [Post] = []
//        var nonFavoritePosts: [Post] = []
//        
//        for post in tableViewPosts {
//            if post.isFavourite ?? false {
//                favoritePosts.append(post)
//            } else {
//                nonFavoritePosts.append(post)
//            }
//        }
//        
//        nonFavoritePosts.sort{ $0.id < $1.id }
//    
//        tableViewPosts = favoritePosts + nonFavoritePosts
//        posts = Array(collectionViewPosts) + tableViewPosts
//    }
//
//    func updateFavoriteStatus(for id: Int, isFavorite: Bool) {
//        for i in 0..<posts.count {
//            if posts[i].id == id {
//                posts[i].isFavourite = isFavorite
//                break
//            }
//        }
//    }
//
//}
    
    
  
