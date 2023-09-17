import XCTest
import Combine
@testable import GBEG

final class GBEGTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestBookSearchModel() {
        
        // Mock
        let mockRequest_1 = BooksSearchRequest(searchWord: "AAA", maxResults: 20)
        let mockRequest_2 = BooksSearchRequest(searchWord: "BBB", maxResults: 10)
        
        let publisher_1 = APIService().request(with: mockRequest_1)
        let publisher_2 = APIService().request(with: mockRequest_2)
        
        XCTAssertNotNil(publisher_1)
        XCTAssertNotNil(publisher_2)
    }
}
