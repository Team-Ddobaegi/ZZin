import Foundation

enum SeoulDistrictOfficeCoordinates: String, CaseIterable {
    case 강남구 = "37.5172363,127.0473248"
    case 강동구 = "37.5301251,127.123762"
    case 강북구 = "37.6396099,127.025657"
    case 강서구 = "37.5509799,126.8495382"
    case 관악구 = "37.4784061,126.9516133"
    case 광진구 = "37.5384843,127.0822939"
    case 구로구 = "37.4954057,126.887369"
    case 금천구 = "37.4568722,126.8953198"
    case 노원구 = "37.6541917,127.0567923"
    case 도봉구 = "37.6687738,127.0470708"
    case 동대문구 = "37.57436819999999,127.03975"
    case 동작구 = "37.512402,126.9392525"
    case 마포구 = "37.566283,126.9014015"
    case 서대문구 = "37.5791158,126.9367789"
    case 서초구 = "37.4837121,127.0324112"
    case 성동구 = "37.5633415,127.0363707"
    case 성북구 = "37.589116,127.0182146"
    case 송파구 = "37.5145437,127.1065971"
    case 양천구 = "37.517075,126.8665425"
    case 영등포구 = "37.5263715,126.8962283"
    case 용산구 = "37.5326006,126.9909831"
    case 은평구 = "37.6026957,126.9291119"
    case 종로구 = "37.5729503,126.9793579"
    case 중구 = "37.5636564,126.9975103"
    case 중랑구 = "37.6065602,127.0926521"
    case 전체 = "37.566381,126.977717"
    
    var coordinate: (latitude: Double, longitude: Double) {
        let values = self.rawValue.split(separator: ",").map(String.init)
        return (Double(values[0])!, Double(values[1])!)
    }
    
    // selectedTown을 기반으로 해당 enum case를 찾는 메서드 추가
    static func find(for town: String) -> SeoulDistrictOfficeCoordinates? {
        return SeoulDistrictOfficeCoordinates.allCases.first { "\($0)" == town }
    }
}

