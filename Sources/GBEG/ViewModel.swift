//
//  ViewModel.swift
//  
//
//  Created by 上條蓮太朗 on 2023/09/17.
//

import Foundation
import Combine

final class BookListViewModel: NSObject, ObservableObject {
    @Published var booksSearchResponse: BooksSearchResponse = .init(items: [])
    @Published var isFetching: Bool = false
    
    // EmptyViewの表示内容
    @Published var type: BookSearchEmptyViewType = .initial
    
    private let apiService = APIService()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private let onBooksSearchSubject = PassthroughSubject<BooksSearchRequest, Never>()
    private var onBooksSearchResponseSubject = PassthroughSubject<BooksSearchResponse, Never>()
    private var cancellables: [AnyCancellable] = []
    
    
    private func requestSend(request: BooksSearchRequest) {
        apiService.request(with: request)
            .catch { [weak self] error -> Empty<BooksSearchResponse, Never> in
                if let `self` = self {
                    self.handleAPIError(error: error)
                }
                return .init()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error: \(error)")
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.isFetching = false
                self.booksSearchResponse = value
                if self.booksSearchResponse.items?.count ?? 0 == 0 {
                    self.type = .noResult
                }
            })
            .store(in: &cancellables)
        
        self.errorSubject
            .sink(receiveValue: { error in
                self.isFetching = false
                self.handleAPIError(error: error)
            })
            .store(in: &cancellables)
    }
    
    private func bind() {
        self.cancellables += [
            // 通信結果
            self.onBooksSearchSubject
                .flatMap { [apiService] (request) in
                    apiService.request(with: request)
                        .catch { [weak self] error -> Empty<BooksSearchResponse, Never> in
                            if let `self` = self {
                                self.errorSubject.send(error)
                            }
                            return .init()
                        }
                }
                .sink(receiveValue: { [weak self] (response) in
                    guard let self = self else { return }
                    self.isFetching = false
                    self.booksSearchResponse = response
                    if self.booksSearchResponse.items?.count ?? 0 == 0 {
                        self.type = .noResult
                    }
                }),
            // エラー
            self.errorSubject
                .sink(receiveValue: { (error) in
                    self.isFetching = false
                    self.handleAPIError(error: error)
                })
        ]
    }
    
    // キーボードの検索ボタンが押されたときにView側から呼び出す
    func resumeSearch(searchWord: String, maxResults: Int) {
        self.cancellables.forEach { $0.cancel() }
        self.isFetching = true
        self.bind()
        self.booksSearchResponse = .init(items: [])
        
        let request: BooksSearchRequest = BooksSearchRequest(searchWord: searchWord, maxResults: maxResults)
        self.requestSend(request: request)
    }
    
    // 通信をキャンセルする
    func cancel() {
        self.isFetching = false
        self.cancellables.forEach { $0.cancel() }
        self.booksSearchResponse = .init(items: [])
    }
    
    // API通信のエラーをさばく
    private func handleAPIError(error: APIServiceError) {
        switch error {
        case .invalidURL:
            print("invalidURL")
        case .responseError:
            print("responseError")
        case let .parseError(error):
            print("parseError: \(error)")
        }
    }
    
}

enum BookSearchEmptyViewType {
    case initial
    case noResult
    case noFavorite
}


