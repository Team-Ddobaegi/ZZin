import Foundation
import Alamofire

class Geocoding {
    static let shared = Geocoding()
    
    private init() {}
    
    func geocodeAddress(query: String, coordinate: String, completion: @escaping (_ coordinate: (lat: Double, lng: Double)?, _ error: Error?) -> ()) {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
            
            // 클라이언트 ID와 시크릿 키 가져오기
            let clientId = Bundle.main.NaverAPIID
            let clientSecret = Bundle.main.NaverAPISecret
            
            let parameters: Parameters = [
                "query": encodedQuery,
                "coordinate": coordinate // 검색 중심 좌표 추가
            ]
            
            let headers: HTTPHeaders = [
                "X-NCP-APIGW-API-KEY-ID": clientId,
                "X-NCP-APIGW-API-KEY": clientSecret
            ]
            
            AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: GeocodeResponse.self) { response in
                switch response.result {
                case .success(let geocodeResponse):
                    if let firstAddress = geocodeResponse.addresses.first {
                        let lat = firstAddress.y
                        let lng = firstAddress.x
                        completion((lat: lat, lng: lng) as! (lat: Double, lng: Double), nil)
                        
                        // API 응답 출력
                        print("JSON Response: \(geocodeResponse)")
                    } else {
                        completion(nil, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                    
                    // 에러 출력
                    print("Geocoding error: \(error.localizedDescription)")
                }
            }
        }
        
    
    func reverseGeocodeCoordinate(coordinate: (lat: Double, lng: Double), completion: @escaping (_ address: String?, _ error: Error?) -> ()) {
        let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        
        // 클라이언트 ID와 시크릿 키 가져오기
        let clientId = Bundle.main.NaverAPIID
        let clientSecret = Bundle.main.NaverAPISecret
        
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
                if let address = reverseGeocodeResponse.results.first {
                    let fullAddress = "\(address.region.area1.name) \(address.region.area2.name) \(address.region.area3.name)"
                    completion(fullAddress, nil)
                    
                    // API 응답 출력
                    print("JSON Response: \(reverseGeocodeResponse)")
                } else {
                    completion(nil, nil)
                }
            case .failure(let error):
                completion(nil, error)
                
                // 에러 출력
                print("Reverse geocoding error: \(error.localizedDescription)")
            }
        }
    }
}

struct GeocodeResponse: Codable {
    let status: String
    let meta: GeocodeMeta
    let addresses: [Address]
    let errorMessage: String
}

struct GeocodeMeta: Codable {
    let totalCount: Int
    let page: Int
    let count: Int
}

struct Address: Codable {
    let roadAddress: String
    let jibunAddress: String
    let englishAddress: String
    let addressElements: [AddressElement]
    let x: String
    let y: String
    let distance: Double
}

struct AddressElement: Codable {
    let types: [String]
    let longName: String
    let shortName: String
    let code: String
}

struct GeocodeStatus: Codable {
    let code: Int
    let name: String
    let message: String
}

struct GeocodeResult: Codable {
    let name: String
    let code: GeocodeCode
    let region: GeocodeRegion
}

struct GeocodeCode: Codable {
    let id: String
    let type: String
    let mappingId: String
}

struct GeocodeRegion: Codable {
    let area0: GeocodeArea
    let area1: GeocodeArea
    let area2: GeocodeArea
    let area3: GeocodeArea
    let area4: GeocodeArea
}

struct GeocodeArea: Codable {
    let name: String
    let coords: GeocodeCoords
}

struct GeocodeCoords: Codable {
    let center: GeocodeCenter
}

struct GeocodeCenter: Codable {
    let crs: String
    let x: Double
    let y: Double
}

struct ReverseGeocodeResponse: Codable {
    let status: ReverseGeocodeStatus
    let results: [ReverseGeocodeResult]
}

struct ReverseGeocodeStatus: Codable {
    let code: Int
    let name: String
    let message: String
}

struct ReverseGeocodeResult: Codable {
    let name: String
    let code: ReverseGeocodeCode
    let region: ReverseGeocodeRegion
}

struct ReverseGeocodeCode: Codable {
    let id: String
    let type: String
    let mappingId: String
}

struct ReverseGeocodeRegion: Codable {
    let area0: ReverseGeocodeArea
    let area1: ReverseGeocodeArea
    let area2: ReverseGeocodeArea
    let area3: ReverseGeocodeArea
    let area4: ReverseGeocodeArea
}

struct ReverseGeocodeArea: Codable {
    let name: String
    let coords: ReverseGeocodeCoords
}

struct ReverseGeocodeCoords: Codable {
    let center: ReverseGeocodeCenter
}

struct ReverseGeocodeCenter: Codable {
    let crs: String
    let x: Double
    let y: Double
}
