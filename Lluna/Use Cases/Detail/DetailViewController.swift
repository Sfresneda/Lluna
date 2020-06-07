//
//  DetailViewController.swift
//  Lluna
//
//  Created by Developer1 on 06/06/2020.
//  Copyright © 2020 com.sfresneda.app. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var sectionTitleArray: [UILabel]!
    @IBOutlet weak var moonInformationTitleLabel: UILabel!
    @IBOutlet weak var userInformationTitleLabel: UILabel!
    
    @IBOutlet var contentTitleArray: [UILabel]!
    @IBOutlet weak var moonriseTitleLabel: UILabel!
    @IBOutlet weak var moonsetTitleLabel: UILabel!
    @IBOutlet weak var moonDistanceTitleLabel: UILabel!
    
    @IBOutlet weak var countryTitleLabel: UILabel!
    @IBOutlet weak var stateTitleLabel: UILabel!
    @IBOutlet weak var cityTitleLabel: UILabel!
    
    @IBOutlet var contentValueArray: [UILabel]!
    @IBOutlet weak var moonriseValueLabel: UILabel!
    @IBOutlet weak var moonsetValueLabel: UILabel!
    @IBOutlet weak var moonDistanceValueLabel: UILabel!
    
    @IBOutlet weak var countryValueLabel: UILabel!
    @IBOutlet weak var stateValueLabel: UILabel!
    @IBOutlet weak var cityValueLabel: UILabel!
    
    
    // MARK: - Vars
    private var networkService: AstronomyNetworkServiceProtocol?
    private let astronomyRequest: AstronomyRequest = AstronomyRequest.init()
    
    private var astronomyModel: Astronomy? {
        didSet {
            self.bindView()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNetworkService()
        self.setupView()
        self.requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Setup
    private func setupView() {
        self.view.backgroundColor = UIColor.lightBlueGrayVlv
        
        self.scrollView.backgroundColor = UIColor.clear
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        self.sectionTitleArray.forEach({
            $0.text = nil
            $0.textColor = UIColor.darkBlackBlueVlv
        })
        
        self.contentTitleArray.forEach({
            $0.text = nil
            $0.textColor = UIColor.darkBlackBlueVlv
        })
        
        self.contentValueArray.forEach({
            $0.text = nil
            $0.textColor = UIColor.darkBlackBlueVlv
        })
    }
    
    private func setupNetworkService() {
        self.networkService = AstronomyNetworkService.init(networkManager: NetworkManager.shared)
    }
    
    private func bindView() {
        self.getUserGeoLocationInformation()
        
        self.moonInformationTitleLabel.text = "Moon Information"
        self.userInformationTitleLabel.text = "User Information"
        
        self.moonriseTitleLabel.text = "Moonrise"
        self.moonsetTitleLabel.text = "Moonset"
        self.moonDistanceTitleLabel.text = "Distance"
        
        self.countryTitleLabel.text = "Country"
        self.cityTitleLabel.text = "City"
        self.stateTitleLabel.text = "State/Province"
        
        self.bindValues()
    }
    
    private func bindValues() {
        guard let model = self.astronomyModel else {
            return
        }
        
        self.moonriseValueLabel.text = model.moonrise
        self.moonsetValueLabel.text = model.moonset
        self.moonDistanceValueLabel.text = String(format: "%.2f", model.moonDistance)
        
        self.countryValueLabel.text = model.location?.countryName ?? "-"
        self.cityValueLabel.text = model.location?.city ?? "-"
        self.stateValueLabel.text = model.location?.stateProvince ?? "-"
        
        if let location = model.location {
            self.centerMapOn(CLLocationCoordinate2D.init(latitude: location.latitude,
                                                         longitude: location.longitude))
        }
    }
    
    // MARK: - Helper
    private func requestData() {
        self.networkService?.getAstronomyData(request: astronomyRequest.request,
                                              completion: { response in
                                                switch response {
                                                case .failure(let error):
                                                    self.showError(with: error.getStringError(),
                                                                   acceptHandler: { _ in
                                                                    self.dismissView()
                                                    })
                                                    
                                                case .succeed(let model):
                                                    self.astronomyModel = model
                                                }
        })
    }
    
    private func getUserGeoLocationInformation() {
        LocationManager.shared.getLocationInformation { userLocation in
            guard let wrappedUserLocation = userLocation else {
                return
            }
            self.astronomyModel?.location = wrappedUserLocation
            self.bindValues()
        }
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func centerMapOn(_ coordinates: CLLocationCoordinate2D?) {
        guard let wrappedCoordinates = coordinates else {
            return
        }
        
        self.mapView.camera = MKMapCamera.init(lookingAtCenter: wrappedCoordinates,
                                               fromDistance: 10000,
                                               pitch: 0,
                                               heading: 90)
    }
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.centerMapOn(userLocation.coordinate)
    }
}
