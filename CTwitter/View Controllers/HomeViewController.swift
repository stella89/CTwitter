import UIKit
import MapKit

class HomeViewController: UIViewController {
	@IBOutlet fileprivate weak var mapView: MKMapView!
	@IBOutlet fileprivate weak var sgcRadius: UISegmentedControl!
	fileprivate let viewModel = HomeViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		configure()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
		viewModel.startObserving()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
		viewModel.stopObserving()
	}
}

fileprivate extension HomeViewController {
	@IBAction func onChangeRadius(_ sender: UISegmentedControl) {
		viewModel.setRadius(radius: sender.value ?? "5km")
	}
	
	func configure() {
		viewModel.setDelegate(delegate: self)
		mapView.delegate = viewModel
		mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
	}
}

extension HomeViewController: HomeViewModelDelegate {
	func willOpenDetail(with viewModel: HomeDetailViewModel) {
		let vc = HomeDetailViewController(viewModel: viewModel)
		
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func willAddAnnotations(annotations: [MKPointAnnotation]) {
		mapView.addAnnotations(annotations)
	}
	
	func willRemoveAnnotations(for tweets: [TWTRTweetExtended]) {
		let tweetIdsString = tweets.map({ $0.tweetID }).joined(separator: ",")
		let annotationsToRemove = mapView.annotations.filter { (annotation) -> Bool in
			if let tweetId = (annotation as? TweetAnnotation)?.tweetId, tweetIdsString.contains(tweetId ) {
				return true
			}
			
			return false
		}
		
		mapView.removeAnnotations(annotationsToRemove)
	}
	
	func willRemoveAnnotations(annotations: [MKPointAnnotation]) {
		mapView.removeAnnotations(annotations)
	}
}

