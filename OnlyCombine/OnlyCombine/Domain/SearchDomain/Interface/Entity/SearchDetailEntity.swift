import Foundation

public struct SearchResultEntity {
    
    let resultCount: Int
    
    let results: [SearchDetailEntity]
    
    
}

struct SearchDetailEntity: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackID)
    }
    
    let trackID, download: Int
    let rating: Double
    let appName, appIcon, description, userName, category: String
    let screenshotUrls: [String]
}
