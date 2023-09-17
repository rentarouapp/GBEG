//
//  APIRequest.swift
//  
//
//  Created by 上條蓮太朗 on 2023/09/17.
//

import Foundation

protocol APIRequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

struct BooksSearchRequest: APIRequestType {
    typealias Response = BooksSearchResponse
    
    var path: String {
        return Constants.bookSearchVolumesPath
    }
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: Constants.queryKey, value: self.searchWord),
            .init(name: Constants.maxResultsKey, value: "\(self.maxResults)")
        ]
    }
    
    public let searchWord: String
    public let maxResults: Int
    
    init(searchWord: String, maxResults: Int) {
        self.searchWord = searchWord
        self.maxResults = maxResults
    }
    
}

