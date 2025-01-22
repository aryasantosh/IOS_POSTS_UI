//
//  NetworkManager.swift
//  NetworkLibrary
//
//  Created by Saichand Pratapagiri on 12/03/21.
//

// NetworkManager.swift

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let posts = try? JSONDecoder().decode([Post].self, from: data)
                completion(posts)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchComments(for postId: Int, completion: @escaping ([Comment]?) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let comments = try? JSONDecoder().decode([Comment].self, from: data)
                completion(comments)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
