import Foundation
import Alamofire

class Geocoding {
    static let shared = Geocoding()
    
    private init() {}
    
    func geocodeAddress(address: String, clientId: String, clientSecret: String, completion: @escaping (_ coordinate: (lat: Double, lng: Double)?, _ error: Error?) -> ()) {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
        
        let parameters: Parameters = [
            "query": encodedAddress
        ]
        
        let headers: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": clientId,
            "X-NCP-APIGW-API-KEY": clientSecret
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: GeocodeResponse.self) { response in
            switch response.result {
            case .success(let geocodeResponse):
                guard let firstAddress = geocodeResponse.addresses.first,
                      let lat = Double(firstAddress.y),
                      let lng = Double(firstAddress.x) else {
                    completion(nil, nil)
                    return
                }
                completion((lat: lat, lng: lng), nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func reverseGeocodeCoordinate(coordinate: (lat: Double, lng: Double), clientId: String, clientSecret: String, completion: @escaping (_ address: String?, _ error: Error?) -> ()) {
            let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
            let parameters: Parameters = [
                "coords": "\(coordinate.lng),\(coordinate.lat)",
                "output": "json"
            ]
            
            let headers: HTTPHeaders = [
                "X-NCP-APIGW-API-KEY-ID": clientId,
                "X-NCP-APIGW-API-KEY": clientSecret
            ]
            
            AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: ReverseGeocodeResponse.self) { response in
                switch response.result {
                case .success(let reverseGeocodeResponse):
                    let address = reverseGeocodeResponse.results.first?.region.area1.name
                    completion(address, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }


struct GeocodeResponse: Codable {
    let addresses: [AddressInfo]
}

struct AddressInfo: Codable {
    let roadAddress: String
    let jibunAddress: String
    let englishAddress: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case roadAddress = "roadAddress"
        case jibunAddress = "jibunAddress"
        case englishAddress = "englishAddress"
        case x, y
    }
}

struct ReverseGeocodeResponse: Codable {
    let results: [Results]
}

struct Results: Codable {
    let region: Region
}

struct Region: Codable {
    let area1: Area
}

struct Area: Codable {
    let name: String
}
