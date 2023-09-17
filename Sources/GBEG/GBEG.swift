import Foundation
import Combine

public final class GBEG {
    
    private let apiService = APIService()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private var cancellables: [AnyCancellable] = []
    
    public init() {
        
    }
    
    /**
     * 検索語句と上限件数を受け取ってGoogleBooksAPIのリクエストを実行し、
     * AnyPublisher（実態はURLSessionのdataTaskPublisher）を返す
     */
    public func booksSearchPublisher(searchWord: String,
                                     maxResults: Int = 20) -> AnyPublisher<BooksSearchResponse, APIServiceError> {
        return APIService().request(with: BooksSearchRequest(searchWord: searchWord, maxResults: maxResults))
    }
    
    
    /**
     * 非同期処理完了後にcopletionで値を受け渡す
     */
    public func resumeBooksSearch(searchWord: String,
                             maxResults: Int = 20,
                             completion: @escaping ((BooksSearchResponse?, APIServiceError?) -> Void)) {
        
        let request: BooksSearchRequest = BooksSearchRequest(searchWord: searchWord, maxResults: maxResults)
        self.apiService.request(with: request)
            .catch { [weak self] error -> Empty<BooksSearchResponse, Never> in
                if let `self` = self {
                    self.errorSubject.send(error)
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
            }, receiveValue: { value in
                completion(value, nil)
            })
            .store(in: &cancellables)
        
        self.errorSubject
            .sink(receiveValue: { error in
                completion(nil, error)
            })
            .store(in: &cancellables)
    }
    
    // 通信をキャンセルする
    public func cancel() {
        self.cancellables.forEach { $0.cancel() }
    }
}
