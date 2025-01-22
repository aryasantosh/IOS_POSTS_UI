//
//  CommentsViewModel.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//
import Foundation

class CommentsViewModel {
    private(set) var comments: [Comment] = []
    var expandedIndexes: Set<Int> = [] // Track expanded comments
    var onCommentsUpdated: (() -> Void)?
    
    func fetchComments(for postId: Int) {
        NetworkManager.shared.fetchComments(for: postId) { [weak self] comments in
            guard let self = self, let comments = comments else { return }
            self.comments = comments
            DispatchQueue.main.async {
                self.onCommentsUpdated?()
            }
        }
    }
    
    func toggleComment(at index: Int) {
        if expandedIndexes.contains(index) {
            expandedIndexes.remove(index)
        } else {
            expandedIndexes.insert(index)
        }
    }
}

