//
//  LocationSearchService.swift
//  Saffy Cleaning
//
//  Created by Rohan Ghevariya on 2022-03-18.
//

import Foundation
import MapKit

class LocationSearchService{
    
    static let service = LocationSearchService()
    
    func searchLocation(text: String,completion: @escaping(SearchLocationData?) -> Void){
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start {(response,Error) in
            if response == nil {
                print("Error")
            }
            else{
                //getting data
                let latitude = response!.boundingRegion.center.latitude
                let longitude = response!.boundingRegion.center.longitude
                let result = SearchLocationData(longitude: longitude, latitude: latitude)
                completion(result)
            }
        }
    }
}

