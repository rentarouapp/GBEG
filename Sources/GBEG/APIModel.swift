//
//  APIModel.swift
//  
//
//  Created by 上條蓮太朗 on 2023/09/17.
//

import Foundation

//全てのデータの構造
public struct BooksSearchResponse: Codable {
    public let items: [BookItem]?
}

//Items内のデータ構造
public struct BookItem: Codable, Identifiable {
    public let id: String?
    public let volumeInfo: VolumeInfo?
}

//VolumeInfo内のデータ構造
public struct VolumeInfo: Codable {
    public let title: String?
    public let authors: [String]?
    public let imageLinks: ImageLinks?
    public let infoLink: String?
    public let publishedDate: String?
    public let description: String?
}

//ImageLinks内のデータ構造
public struct ImageLinks: Codable {
    public let thumbnail: String?
    public let smallThumbnail: String?
}


