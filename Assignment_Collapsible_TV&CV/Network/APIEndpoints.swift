//
//  constants.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 25/01/25.
//

// Constants.swift
// APIEndpoints.swift
import Foundation

struct APIEndpoints {
    static let postsURL = "https://jsonplaceholder.typicode.com/posts"
    
    static func commentsURL(postId: Int) -> String {
        return "https://jsonplaceholder.typicode.com/posts/\(postId)/comments"
    }
}
