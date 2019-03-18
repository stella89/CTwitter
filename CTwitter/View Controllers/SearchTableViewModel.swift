import UIKit
import TwitterKit

class SearchTableViewModel: NSObject {
	private let client = TWTRAPIClient.withCurrentUser()
	
	func generateDataSource(query: String?) -> TWTRSearchTimelineDataSource {
		return TWTRSearchTimelineDataSource(searchQuery: query ?? "canada", apiClient: client)
	}
}
