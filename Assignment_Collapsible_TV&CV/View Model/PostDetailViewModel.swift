//
//  PostDetailViewModel.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//

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
        apiService.fetchComments(for: post.id) { [weak self] result in
            switch result {
            case .success(let comments):
                self?.comments = comments
                self?.onCommentsUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
