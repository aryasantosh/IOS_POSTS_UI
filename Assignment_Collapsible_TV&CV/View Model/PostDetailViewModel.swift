//
//  PostDetailViewModel.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.

//ViewModel acts as a bridge between the View and the API, ensuring clean separation and handle logic.

import Foundation

class PostDetailViewModel {
    private let apiService = APIService()
    
    func fetchComments(postId: Int, onCommentsUpdated: (([Comment]) -> ())?, onError: ((String) -> Void)?) {
        //Calls the apiService to fetch comments for the current post.id
        apiService.fetchComments(for: postId) { result in
            switch result {
                //Updates the comments array with the fetched comments.
            case .success(let comments):
                onCommentsUpdated?(comments)
                //error message for handling
            case .failure(let error):
                onError?(error.localizedDescription)
            }
        }
    }
}
