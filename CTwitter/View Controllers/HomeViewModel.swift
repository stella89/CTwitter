import UIKit
import TwitterKit
import MapKit
import AlamofireImage

protocol HomeViewModelDelegate: class {
	func willAddAnnotations(annotations: [MKPointAnnotation])
	func willRemoveAnnotations(for tweets: [TWTRTweetExtended])
	func willOpenDetail(with viewModel: HomeDetailViewModel)
}

class HomeViewModel: NSObject {
	private weak var delegate: HomeViewModelDelegate?
	private var tweets: [TWTRTweetExtended]?
	private var isUserLocationUpdated = false
	
	override init() {
		super.init()
		GeocodeTweetsObserver.instance.addObserver(self)
	}
	
	deinit {
		GeocodeTweetsObserver.instance.removeObserver(self)
	}
	
	func setDelegate(delegate: HomeViewModelDelegate) {
		self.delegate = delegate
	}
	
	func setRadius(radius: String) {
		GeocodeTweetsObserver.instance.setRadius(radius: radius)
	}
	
	func startObserving() {
		GeocodeTweetsObserver.instance.startObserving()
	}
	
	func stopObserving() {
		GeocodeTweetsObserver.instance.startObserving()
	}
}

fileprivate extension HomeViewModel {
	func annotations(for tweets: [TWTRTweetExtended]) -> [TweetAnnotation] {
		let annotations = tweets.reduce(into: [TweetAnnotation](), { (annotations, tweet) in
			
			if let lat = tweet.latitude, let lon = tweet.longitude {
				let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(CGFloat(lat)),longitude: CLLocationDegrees(CGFloat(lon)))
				let annotation = TweetAnnotation()
				
				annotation.coordinate = location
				annotation.username = tweet.author.screenName
				annotation.name = tweet.author.name
				annotation.imageUrl = tweet.author.profileImageURL
				annotation.tweetId = tweet.tweetID
				annotations.append(annotation)
			}
		})
		
		return annotations
	}
}
extension HomeViewModel: GeocodeTweetsObserverDelegate {
	func willUpdateTweets(allTweets: [TWTRTweetExtended], tweetsToRemove: [TWTRTweetExtended], newTweets: [TWTRTweetExtended]) {
		self.tweets = allTweets
		
		if newTweets.count > 0 {
			delegate?.willAddAnnotations(annotations: annotations(for: newTweets))
		}
		
		if tweetsToRemove.count > 0 {
			delegate?.willRemoveAnnotations(for: tweetsToRemove)
		}
	}
}

extension HomeViewModel: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if !self.isUserLocationUpdated {
			let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
			
			mapView.setRegion(region, animated: true)
			isUserLocationUpdated = true
		}
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if let annotation = view.annotation as? TweetAnnotation {
			if let tweet = tweets?.first(where: { $0.tweetID == annotation.tweetId}) {
				delegate?.willOpenDetail(with: HomeDetailViewModel(tweet: tweet))
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? TweetAnnotation else {
			return nil
		}
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
		let calloutView =  TweetCalloutView.build()
		
		if annotationView == nil {
			annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
			annotationView?.canShowCallout = true
		} else {
			annotationView?.annotation = annotation
		}

		calloutView.configure(name: annotation.name, username: annotation.username, profileUrl: annotation.imageUrl)
		annotationView?.clusteringIdentifier = "Tweet"
		annotationView?.detailCalloutAccessoryView = calloutView
		annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		return annotationView
	}
}
