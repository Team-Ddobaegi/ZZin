import Foundation
import Alamofire

class Geocoding {
    static let shared = Geocoding()
    
    private init() {}
    
    func geocodeAddress(query: String, coordinate: String, completion: @escaping (_ response: GeocodeResponse?, _ error: Error?) -> ()) {
        let url = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
        
        // 클라이언트 ID와 시크릿 키 가져오기
        let clientId = Bundle.main.NaverAPIID
        let clientSecret = Bundle.main.NaverAPISecret
        
        let parameters: [String: Any] = [
            "query": query,
            "coordinate": coordinate
        ]
        
        let headers: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": clientId,
            "X-NCP-APIGW-API-KEY": clientSecret
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: GeocodeResponse.self) { response in
            switch response.result {
            case .success(let geocodeResponse):
                completion(geocodeResponse, nil)
                
                // API 응답 출력
//                print("#####JSON Response: \(geocodeResponse)")
            case .failure(let error):
                completion(nil, error)
                
                // 에러 출력
                print("Geocoding error: \(error.localizedDescription)")
            }
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: (lat: Double, lng: Double), completion: @escaping (_ detailedAddress: String?, _ error: Error?) -> ()) {
        let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        
        // 클라이언트 ID와 시크릿 키 가져오기
        let clientId = Bundle.main.NaverAPIID
        let clientSecret = Bundle.main.NaverAPISecret
        
        let parameters: Parameters = [
            "coords": "\(coordinate.lng),\(coordinate.lat)",
            "output": "json",
            "orders": "roadaddr,addr" // 도로명 주소와 지번 주소 모두 요청
        ]
        
        let headers: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": clientId,
            "X-NCP-APIGW-API-KEY": clientSecret
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonResponse = value as? [String: Any],
                   let results = jsonResponse["results"] as? [[String: Any]] {
                    
                    // 도로명 주소 결과를 우선 시도
                    if let roadAddressResult = results.first(where: { $0["name"] as? String == "roadaddr" }),
                       let region = roadAddressResult["region"] as? [String: Any],
                       let area1 = region["area1"] as? [String: Any],
                       let area2 = region["area2"] as? [String: Any],
                       let land = roadAddressResult["land"] as? [String: Any],
                       let addition0 = land["addition0"] as? [String: Any] {
                        
                        let detailedAddress = [
                            area1["name"] as? String,
                            area2["name"] as? String,
                            land["name"] as? String,
                            land["number1"] as? String,
                            addition0["value"] as? String
                        ].compactMap { $0 }.joined(separator: " ")
                        
                        completion(detailedAddress, nil)
                    // 도로명 주소 결과가 없을 경우 지번 주소로 대체
                    } else if let addrResult = results.first(where: { $0["name"] as? String == "addr" }),
                              let region = addrResult["region"] as? [String: Any],
                              let area1 = region["area1"] as? [String: Any],
                              let area2 = region["area2"] as? [String: Any],
                              let area3 = region["area3"] as? [String: Any],
                              let land = addrResult["land"] as? [String: Any] {
                        
                        let detailedAddress = [
                            area1["name"] as? String,
                            area2["name"] as? String,
                            area3["name"] as? String,
                            land["number1"] as? String
                        ].compactMap { $0 }.joined(separator: " ")
                        
                        completion(detailedAddress, nil)
                    } else {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No address found"]))
                    }
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }



}

struct GeocodeResponse: Codable {
    let status: String
    let meta: GeocodeMeta
    let addresses: [Address]
    let errorMessage: String?
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

struct Land: Codable {
    let name: String?
    let number1: String?
}

struct Addition0: Codable {
    let type: String?
    let value: String?
}

struct ReverseGeocodeResult: Codable {
    let name: String
    let code: ReverseGeocodeCode
    let region: ReverseGeocodeRegion
    let land: Land?           // 추가된 부분
    let addition0: Addition0? // 추가된 부분
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
