//
//  Post.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//
import UIKit

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    let imageURL: String?
}


