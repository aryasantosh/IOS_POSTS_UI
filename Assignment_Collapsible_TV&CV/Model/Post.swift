//
//  Post.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//

import Foundation
struct Post: Codable ,Equatable {
    let userId: Int
    let id: Int
    var title: String
    var body: String
    var isFavourite: Bool? = false // Default value is false
}

