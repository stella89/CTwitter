import UIKit
import CoreLocation

protocol LocationManagerDelegate {
	func didChangeLocation(latitude: Double, longitude: Double)
}

class LocationManager: NSObject {
	static let instance = LocationManager()
	fileprivate let refreshDistance = 500.0
	fileprivate let locationManager = CLLocationManager()
	fileprivate(set) var isAuthorized = false
	fileprivate(set) var isUpdating = false
	fileprivate var currentLocation: CLLocation?
	var currentCoordinate: CLLocationCoordinate2D? {
		return currentLocation?.coordinate
	}
	fileprivate var observers = [(LocationManagerDelegate & NSObject)]()

	override init() {
		super.init()
		enableLocationServices()
	}
	
	deinit {
		observers.removeAll()
	}
	
	func stopUpdating() {
		if isUpdating {
			locationManager.stopUpdatingLocation()
			isUpdating = false
		}
	}
	
	func startUpdating() {
		if !isUpdating {
			locationManager.startUpdatingLocation()
		}
	}
	
	func addObserver(_ observer: (LocationManagerDelegate & NSObject)) {
		observers.append(observer)
	}
	
	func removeObserver(_ observer: (LocationManagerDelegate & NSObject)) {
		if let idx = observers.firstIndex(where: { ( $0 === observer )}) {
			observers.remove(at: idx)
		}
	}
}

fileprivate extension LocationManager {
	func enableLocationServices() {
		self.locationManager.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
		}
	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		isAuthorized = (status == .authorizedWhenInUse)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		isUpdating = true
		
		if let lastLocation = locations.last {
			if currentLocation == nil || (currentLocation != nil && refreshDistance.isLess(than: currentLocation!.distance(from: lastLocation))) {
				currentLocation = lastLocation
				observers.forEach({ $0.didChangeLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)})
			}
		}
	}
}
