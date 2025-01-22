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
    private(set) var posts: [Post] = []
    var topPosts: [Post] {
        Array(posts.prefix(10))
    }
    var remainingPosts: [Post] {
        Array(posts.dropFirst(10))
    }
    
    var onPostsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchPosts() {
        apiService.fetchPosts { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                self?.onPostsUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}

