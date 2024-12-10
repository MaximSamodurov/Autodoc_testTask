//
//  NewsFeedViewModel.swift
//  Autodoc_testTask
//
//  Created by Fixed on 03.12.24.
//

import Foundation
import Combine
import UIKit

class NewsFeedViewModel {

    @Published var isLoading: Bool?
    @Published var erorrAlert: Error?
    @Published var newsCellViewModel = [NewsCellViewModel]()
    
    private let baseURL = Constants.baseURL
    private let apiService: ApiServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
        loadData()
        
        apiService.errorHandler.sink { error in
            self.erorrAlert = error
        }.store(in: &cancellables)
    }
    
    private func fetchCellViewModel(page: Int) async throws -> [NewsCellViewModel] {
        let url = "\(baseURL)/\(page)/15"
        return try await apiService.fetchData(from: url)
    }
    
    func loadData() {
        Task {
            self.isLoading = true
            do {
                let fetchData = try await fetchCellViewModel(page: currentPage)
                newsCellViewModel.append(contentsOf: fetchData)
                currentPage += 1
            } catch {
                erorrAlert = error
            }
            self.isLoading = false
        }
    }
}


