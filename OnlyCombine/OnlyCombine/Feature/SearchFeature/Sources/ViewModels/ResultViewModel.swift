import Foundation
import Combine
import SwiftUI

final class ResultViewModel: BaseViewModel  {
        

    let fetchSearchResultUseCase: any FetchSearchResultUseCase
    let text: String
    
    @Published var results: [SearchDetailEntity] = []
    
    
    init(text: String, fetchSearchResultUseCase: any FetchSearchResultUseCase) {
        self.text = text
        self.fetchSearchResultUseCase = fetchSearchResultUseCase
        super.init()
        bind()
    }
    
    override func bind() {
        
        fetchSearchResultUseCase
            .execute(text: text, limit: 20)
            .withUnretained(self)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { owner, entity in
                owner.results = entity.results
            })
            .store(in: &subscription)

        
        
    }
    
    
}
