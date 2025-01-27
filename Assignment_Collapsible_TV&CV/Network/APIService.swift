//
//  APIService.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 21/01/25.
//

import Foundation

class APIService {
    // Generic fetch function
    private func fetchData<T: Decodable>(url: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.serializationError(error)))
            }
        }.resume()
    }
    
    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        fetchData(url: APIEndpoints.postsURL, completion: completion)
    }
    
    func fetchComments(for postId: Int, completion: @escaping (Result<[Comment], APIError>) -> Void) {
        let url = APIEndpoints.commentsURL(postId: postId)
        fetchData(url: url, completion: completion)
    }
}

// Enum for API Errors
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case serializationError(Error)
}



// APIService.swift
//import Foundation
//
//class APIService { //<--- TODO: Remove duplicate codes here, if possible follow router architecture.
//    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return } //TODO: Keep the end points in a constant file.
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            guard let data = data else { return } //TODO: Don't just return, create an enum of errors , define them like No internet, unable to serialise,
//            do {
//                let posts = try JSONDecoder().decode([Post].self, from: data)
//                completion(.success(posts))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    func fetchComments(for postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments") else { return }
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            guard let data = data else { return }
//            do {
//                let comments = try JSONDecoder().decode([Comment].self, from: data)
//                completion(.success(comments))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
