//
//  GeoLocationService.swift
//  LiveStream
//
//  Created by LuanMa on 16/7/12.
//  Copyright © 2016年 sip. All rights reserved.
//

import CoreLocation
import Result
import MeMeKit
import RxSwift

public class GeoLocationService: NSObject {
	public static let shared = GeoLocationService()
	public static var allow: Bool {
		return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
	}

	fileprivate lazy var locationManager: CLLocationManager = {
		let locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.distanceFilter = 500
		return locationManager
	}()

	public var lastLocation: CLLocation?
	public var lastPlacemark: CLPlacemark?
	public var locationChanged: ((CLPlacemark) -> Void)?
    public lazy var locationChangedBehaviorObser:BehaviorSubject<CLPlacemark?> = {
        let obser = BehaviorSubject<CLPlacemark?>(value:lastPlacemark)
        return obser
    }()
    
    public lazy var locationChangedPublishObser:PublishSubject<CLPlacemark> = {
        let obser = PublishSubject<CLPlacemark>()
        return obser
    }()
    
    public lazy var authorizationChangedPublishObser:PublishSubject<CLAuthorizationStatus> = {
        let obser = PublishSubject<CLAuthorizationStatus>()
        return obser
    }()

	fileprivate override init() {
		super.init()
	}

    public func startUpdatingLocation(withRequest:Bool = true) {
		switch CLLocationManager.authorizationStatus() {
		case .notDetermined:
            if withRequest {
                locationManager.requestWhenInUseAuthorization()
            }
		case .authorizedWhenInUse, .authorizedAlways:
			if CLLocationManager.locationServicesEnabled() {
				locationManager.startUpdatingLocation()
			} else {
//                log.error("Location service is disabled!")
            }
        case .denied, .restricted:
            ""//防止语法错误
//            log.error("Location .denied, .restricted")
        default:
			break
		}
	}
    
    public func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

	public class func getPlacemarkFromLocation(_ location: CLLocation, completion: @escaping (Result<CLPlacemark?, NSError>) -> Void) {
		let geoCoder = CLGeocoder()
		geoCoder.reverseGeocodeLocation(location) { placemarks, error in
			if let error = error as NSError? {
//				log.error("\(error.localizedDescription)")
				completion(.failure(error))
			} else {
				completion(.success(placemarks?.first))
			}
		}
	}
}

extension GeoLocationService: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			manager.startUpdatingLocation()
		default:
			break
		}
        authorizationChangedPublishObser.onNext(status)
    }
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
        authorizationChangedPublishObser.onNext(status)
    }
    
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else {
			return
		}

		lastLocation = location
		GeoLocationService.getPlacemarkFromLocation(location) { [weak self] result in
			switch result {
			case .success(let value):
				if let placemark = value {
					self?.lastPlacemark = placemark
					self?.locationChanged?(placemark)
                    self?.locationChangedBehaviorObser.onNext(placemark)
                    self?.locationChangedPublishObser.onNext(placemark)
				}
				self?.locationManager.stopUpdatingLocation()
			case .failure:
				break
			}
		}
	}
}

extension CLPlacemark {
	public var stream_location: String? {
		if let city = locality {
			return city
		} else if let area = administrativeArea {
			return area
		} else if let country = country {
			return country
		} else {
			return nil
		}
	}
}
