//
//  PostDetailViewModel.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//If [weak self] is used, the object (like a screen or feature) won’t stick around forever. It’ll be released properly when it’s no longer needed.
//ViewModel acts as a bridge between the View and the API, ensuring clean separation and handle logic.

import Foundation

class PostDetailViewModel {
    private let apiService = APIService()
    private(set) var comments: [Comment] = []
    var post: Post
    var onCommentsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(post: Post) {
        self.post = post
    }

    func fetchComments() {
        //Calls the apiService to fetch comments for the current post.id
        apiService.fetchComments(for: post.id) { [weak self] result in
            switch result {
        //Updates the comments array with the fetched comments.
            case .success(let comments):
                self?.comments = comments
                self?.onCommentsUpdated?()  //notify the UI to refresh
        //error message for handling
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
