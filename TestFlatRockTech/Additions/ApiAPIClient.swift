//
//  ApiAPIClient.swift
//  TestFlatRockTech
//
//  Created by Sos Avetyan on 5/17/22.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

extension HTTPHeader {
    static var contentType: HTTPHeader {
        return HTTPHeader(field: "Accept", value: "application/vnd.github.v3+json")
    }
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    let baseUrl: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    var specialEncodingCharacterSet: CharacterSet?
    
    init(method: HTTPMethod, path: String, baseUrl: String) {
        self.method = method
        self.path = path
        self.baseUrl = baseUrl
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: String, baseUrl: String, body: Body) throws {
        self.method = method
        self.path = path
        self.baseUrl = baseUrl
        self.body = try JSONEncoder().encode(body)
    }
}

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
    let cookies: [HTTPCookie]
    
    init(statusCode: Int, body: Body, cookies: [HTTPCookie] = []) {
        self.statusCode = statusCode
        self.body = body
        self.cookies = cookies
    }
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode,
                                     body: decodedJSON)
    }
}

struct FailureResponse<Body> {
    let statusCode: Int?
    let body: APIError
}

struct APIErrorResponse: Decodable {
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case message
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case badRequest
    case decodingFailure
    case passforFailure
    case noInternet
    case badResponse
    case errorWithString(date: Data)
    case errorWithInfo(info: APIErrorResponse)
}

enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(FailureResponse<Body>)
}

struct APIClient {
    
    typealias APIClientCompletion = (APIResult<Data?>) -> Void
    
    private let session: URLSession
    
    init() {
        session = URLSession.shared
        session.configuration.httpCookieAcceptPolicy = .always
    }
    
    func get(_ path: String, _ completion: @escaping APIClientCompletion) {
        
    }
    
    func perform(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {
        let baseURL = URL(string: request.baseUrl)!
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        if let characterSet = request.specialEncodingCharacterSet {
            urlComponents.percentEncodedQuery = request.queryItems?.map { item in
                let encodedValue = item.value?.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
                let separator = encodedValue.isEmpty ? "" : "="
                return item.name + separator + encodedValue
            }.joined(separator: "&")
        }
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .invalidURL))); return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        urlRequest.timeoutInterval = 3000
        let startDate = Date()
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        let postTask = session.dataTask(with: urlRequest.debugLog()) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            self.log(data: data, response: response as? HTTPURLResponse, error: error)
            let requestExecutionTime = Date().timeIntervalSince(startDate)
            if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .noInternet)))
            } else if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorBadServerResponse {
                completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .badResponse)))
            } else {
                print("REQUESTTTT EXECUTION TIMMMEEEE =========\(requestExecutionTime)")
                guard let httpResponse = response as? HTTPURLResponse else {
                    let executionTimeWithError = Date().timeIntervalSince(startDate)
                    print("REQUESTTTT==== ERRRRRROOOOORRRR==== EXECUTION TIMMMEEEE =========\(executionTimeWithError)")
                    completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .requestFailed))); return
                }
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 404 {
                        if let uData = data, let errorInfo = try? JSONDecoder().decode(APIErrorResponse.self, from: uData) {
                            completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .errorWithInfo(info: errorInfo))))
                        } else {
                            completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .errorWithString(date: data!))))
                        }
                        
                    } else {
                        completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .requestFailed)))
                    }
                    return
                }
                let executionTimeWithSuccess = Date().timeIntervalSince(startDate)
                
                print("REQUESTTTT==== SUCCESSSSSSS==== EXECUTION TIMMMEEEE =========\(executionTimeWithSuccess)")
                
                var cookies = [HTTPCookie]()
                if let headers = httpResponse.allHeaderFields as? [String: String], let url = httpResponse.url {
                    cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                    
                    if let dateValue = headers["Date"],
                       let dateCookie = HTTPCookie(properties: [.originURL: url, .path: "/", .name: "Date", .value: dateValue]) {
                        cookies.append(dateCookie)
                    }
                }
                
                
                completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data, cookies: cookies)))
            }
        }
        postTask.resume()
    }
    
    fileprivate func log(data: Data?, response: HTTPURLResponse?, error: Error?) {
        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        
        var responseLog = " \n <---------- IN ---------- \n "
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }
        
        if let statusCode =  response?.statusCode {
            responseLog += "HTTP \(statusCode) \(path)?\(query) \n "
        }
        if let host = components?.host {
            responseLog += "Host: \(host) \n "
        }
        for (key, value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value) \n "
        }
        if let body = data {
            responseLog += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")\n"
        }
        if error != nil {
            responseLog += " \n Error: \(error!.localizedDescription) \n "
        }
        
        responseLog += "<------------------------ \n "
        print(responseLog)
    }
}

extension URLRequest {
    public func debugLog() -> URLRequest {
        let urlString = self.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)
        
        let method = self.httpMethod != nil ? "\(self.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"
        
        var requestLog = " \n ---------- OUT ----------> \n "
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1 \n "
        requestLog += "Host: \(host)\n"
        for (key,value) in self.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value) \n "
        }
        if let body = self.httpBody{
            requestLog += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")\n"
        }
        
        requestLog += " \n -------------------------> \n ";
        print(requestLog)
        return self
    }
}

