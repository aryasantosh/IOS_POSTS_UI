//
//  UserDefaultsManager.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 27/01/25.
//

import Foundation

class UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()  //singleton
    private let favoritesKey = "favoritePosts" //make sure the data is associated with the correct value
    
    private init() {}
    
    //Key: "favoritePosts", Value: Encoded Data of Posts
    func saveFavoritePosts(_ posts: [Post]) {
        let encoder = JSONEncoder()  //not readadble
        if let encoded = try? encoder.encode(posts) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    func fetchFavoritePosts() -> [Post] {
        if let savedPostsData = UserDefaults.standard.data(forKey: favoritesKey) {
            let decoder = JSONDecoder() //readable
            if let savedPosts = try? decoder.decode([Post].self, from: savedPostsData) {
                return savedPosts
            }
        }
        return []
    }
    
    
}
