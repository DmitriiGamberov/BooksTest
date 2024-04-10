//
//  NetworkManager.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import Foundation
import Network

enum HTTPMethod: String, Codable {
    case GET = "GET"
}

final class NetworkManager: NSObject {
    let baseURL = URL(string: "https://my-json-server.typicode.com/KeskoSenukaiDigital/assignment/")! // Not so safe, better to init this manager with stored API url somewhere
    private let session = URLSession(configuration: .default)
    
    //MARK: - General
    func requestWith<T:Decodable>(_ pathURL:URL, method:HTTPMethod, completion:@escaping(T?, NSError?)->Void) -> URLSessionTask? {
        do {
            let request = try requestFrom(pathURL: pathURL, method: method)
            let task = session.dataTask(with: request) {[weak self] (data, response, error) in
                guard let self = self else { return }
                self.handleDataTaskResponse(data: data, response: response, error: error, completion: completion, pathURL: pathURL)
            }
            task.resume()
            return task
        } catch let someError {
            completion(nil, someError as NSError)
            return nil
        }
    }
    
    
    // MARK: - Private
    private func requestFrom(pathURL:URL, method:HTTPMethod) throws -> URLRequest {
        let urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)
        
        guard let url = urlComponents?.url else {
            throw NSError(domain: "NetworkManager", code: 0, userInfo: [NSLocalizedDescriptionKey:"Can't create request"])
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.timeoutInterval = 60
        
        return request
    }
    
    private func handleDataTaskResponse<T:Decodable>(data:Data?, response:URLResponse?, error:Error?, completion:(T?, NSError?)->Void, pathURL: URL? = nil) {
        guard let data else {
            completion(nil, error as NSError?)
            return
        }
        
        let decoder = JSONDecoder.baseDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            completion(result, nil)
        } catch let jsonError as NSError {
            let newJsonError = NSError(domain: jsonError.domain, code: jsonError.code, userInfo: [NSLocalizedDescriptionKey: "JSON parsing error"])
            completion(nil, newJsonError)
        }
    }
}
