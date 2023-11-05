import Foundation

extension Bundle {
    var NaverAPIID: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "NAVER_CLIENT_ID") as? String else {
                fatalError("Couldn't find key 'NAVER_CLIENT_ID' in 'SecretKey.plist'.")
            }
            return value
        }
    }
    var NaverAPISecret: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "NAVER_CLIENT_SECRET") as? String else {
                fatalError("Couldn't find key 'NAVER_CLIENT_SECRET' in 'SecretKey.plist'.")
            }
            return value
        }
    }
}
