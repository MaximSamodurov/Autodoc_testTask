//
//  APIService.swift
//  Autodoc_testTask
//
//  Created by Fixed on 02.12.24.
//

import UIKit
import Combine

protocol ApiServiceProtocol {
    var errorHandler: PassthroughSubject<Error, Never> { get }
    func fetchData(from jsonUrl: String) async throws -> [NewsCellViewModel]
}

class APIService: ApiServiceProtocol {
    
    static let shared = APIService(urlSession: .shared)
    
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    var errorHandler = PassthroughSubject<Error, Never>()
    
    private init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func fetchAndDecodeJSON(from urlString: String) async throws -> [News] {
        do {
            guard let url = URL(string: urlString) else { throw ErrorHandling.invalidURL }
            let (data, response) = try await urlSession.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ErrorHandling.serverError }
            guard let decodedData = try? JSONDecoder().decode(Welcome.self, from: data) else { throw ErrorHandling.invalidData }
            return decodedData.news
        } catch {
            errorHandler.send(error)
            throw error
        }
    }
    
    func fetchImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw ErrorHandling.invalidURL }
        let (data, response) = try await urlSession.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ErrorHandling.serverError }
        guard let image = UIImage(data: data) else {
            return UIImage()
        }
        
        return image
    }
    
    func fetchImages(from urls: [String]) async throws -> [UIImage] {
        var images = [UIImage?](repeating: nil, count: urls.count)
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, url) in urls.enumerated() {
                group.addTask { [weak self] in
                    do {
                        let image = try await self?.fetchImage(from: url)
                        return (index, image)
                    } catch {
                        return (index, UIImage(named: Constants.placeholderImageName) ?? UIImage())
                    }
                }
            }

            for await (index, image) in group {
                images[index] = image
            }
        }
        return images.compactMap { $0 }
    }
    
    func fetchData(from jsonUrl: String) async -> [NewsCellViewModel] {
        var cellVm = [NewsCellViewModel]()
        
        do {
            let data = try await fetchAndDecodeJSON(from: jsonUrl)
            let imageUrls = data.map { $0.titleImageURL ?? "" }
            let images = try await fetchImages(from: imageUrls)
            
            var newsImages = [UIImage]()
            var newsResult = [News]()
            
            newsImages.append(contentsOf: images)
            newsResult.append(contentsOf: data)
            
            cellVm = zip(newsResult, newsImages).map { news, image in
                NewsCellViewModel(fullURL: news.fullURL, title: news.title, image: image)
            }
            
        } catch {
            print("error: \(error)")
        }
        
        return cellVm
    }
}
