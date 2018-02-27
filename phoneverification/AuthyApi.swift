import Foundation

enum AuthyError: Error {
    case invalidUrl
    case err(String)
}


protocol WithMessage {
    var message: String { get }
}

enum AuthyResult {
    case success(WithMessage)
    case failure(Error)
}


class DataResult: WithMessage {
    let data: Data
    let message: String
    
    init(data: Data) {
        self.data = data
        self.message = String(describing: data)
    }
}

struct CheckResult: Codable, WithMessage {
    let success: Bool
    let message: String
}




struct AuthyAPI {
    private static let baseURLString = "https://api.authy.com/protected/json"
    
    static let path = Bundle.main.path(forResource: "Keys", ofType: "plist")
    static let keys = NSDictionary(contentsOfFile: path!)
    static let apiKey = keys!["apiKey"] as! String
    
    static func createRequest(_ path: String,
                              _ method: String,
                              _ parameters: [String: String],
                              completionHandler: @escaping (_ result: Data) -> AuthyResult) {
        
        let urlPath = "\(baseURLString)/\(path)"
        var components = URLComponents(string: urlPath)!
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        let url = components.url!
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Authy-API-Key")
        request.httpMethod = method
        
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            if let jsonData = data {
                let result = completionHandler(jsonData)
                print(result)
            } else {
                // error, no data returned
            }
        }
        task.resume()
    }
    
    static func sendVerificationCode(_ phoneNumber: String) {
        let parameters = [
            "api_key": apiKey,
            "via": "sms",
            "country_code": "1",
            "phone_number": phoneNumber
        ]
        
        createRequest("phones/verification/start", "POST", parameters) {
            json in
            print(json)
            return .success(DataResult(data: json))
        }
    }
    
    static func validateVerificationCode(_ phoneNumber: String, _ code: String, segue: @escaping (CheckResult) -> Void) {
        
        let parameters = [
            "api_key": apiKey,
            "via": "sms",
            "country_code": "1",
            "phone_number": phoneNumber,
            "verification_code": code
        ]
        
        createRequest("phones/verification/check", "GET", parameters) {
            jsonData in
            
            let decoder = JSONDecoder()
            do {
                let checked = try decoder.decode(CheckResult.self, from: jsonData)
                DispatchQueue.main.async(execute: {
                    segue(checked)
                })
                return AuthyResult.success(checked)
            } catch {
                return AuthyResult.failure(AuthyError.err("failed to deserialize"))
            }
        }
    }
}
