//
//  APIModel.swift
//  
//
//  Created by 上條蓮太朗 on 2023/09/17.
//

import Foundation

//全てのデータの構造
public struct BooksSearchResponse: Codable {
    let items: [BookItem]?
}

//Items内のデータ構造
public struct BookItem: Codable, Identifiable {
    public let id: String?
    let volumeInfo: VolumeInfo?
}

//VolumeInfo内のデータ構造
public struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let imageLinks: ImageLinks?
    let infoLink: String?
    let publishedDate: String?
    let description: String?
}

//ImageLinks内のデータ構造
public struct ImageLinks: Codable {
    let thumbnail: String?
    let smallThumbnail: String?
}


