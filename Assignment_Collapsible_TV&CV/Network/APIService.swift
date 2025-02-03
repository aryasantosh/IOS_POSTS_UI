//
//  APIService.swift
//  Assignment_Collapsible_TV&CV
//In my APIService class, I use Swift’s JSONDecoder to serialize JSON data into Swift objects. Specifically, after fetching the data using URLSession.shared.dataTask, I attempt to decode it using JSONDecoder().decode(T.self, from: data), where T is a generic type conforming to Decodable. This allows the function to decode different types of objects, such as Post or Comment, depending on the API response. If decoding fails, I handle the error using the APIError.serializationError case, ensuring that any issues in data conversion are properly caught and managed.
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
        
        URLSession.shared.dataTask(with: url) { data, _, error in  //makes network request
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            //tries to decode it into expected type T (generic type) swift objects.
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.serializationError(error)))
            }
        }.resume()
    }
    
    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        fetchData(url: APIEndpoints.postsURL, completion: completion) //fetch data with url
    }
    
    func fetchComments(for postId: Int, completion: @escaping (Result<[Comment], APIError>) -> Void) {
        let url = APIEndpoints.commentsURL(postId: postId)
        fetchData(url: url, completion: completion)
    }
}
//convert that JSON into a struct or class
// Enum for API Errors
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case serializationError(Error) //converts data from one format (like JSON) into a usable Swift object
} //If you have a Post object that expects a title of type String but the server returns it as an Int



