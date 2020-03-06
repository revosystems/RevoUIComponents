import XCTest

class ImageViewDownloadTest: XCTestCase {

    let testImageUrl = "https://www.google.es/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"
    
    func test_it_can_download_an_image(){
        let expectation = XCTestExpectation(description: "timeout")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        XCTAssertNil(imageView.image)
        imageView.downloaded(from: URL(string: testImageUrl)!) { data in
            expectation.fulfill()
            XCTAssertNotNil(imageView.image)
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_image_is_cached(){
        let expectation = XCTestExpectation(description: "timeout")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        
        XCTAssertNil(imageView.image)
        imageView.downloaded(from: URL(string: testImageUrl)!) { data in
            expectation.fulfill()
            XCTAssertNotNil(imageView.image)
            XCTAssertNotNil(imageView.loadFromCache(link: self.testImageUrl))
        }
        wait(for: [expectation], timeout: 5)
    }
}
