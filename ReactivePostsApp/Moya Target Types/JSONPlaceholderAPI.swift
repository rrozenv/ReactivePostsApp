
import Foundation
import Moya

enum JSONPlaceholderAPI {
    case posts
    case comments(postId: Int)
    case users
}

extension JSONPlaceholderAPI: TargetType {
    
    // 3:
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    // 4:
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .comments(postId: let id):
            return "/posts/\(id)/comments"
        case .users:
            return "/users"
        }
    }
    
    // 5:
    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
    // 6:
    var parameters: [String: Any]? {
        switch self {
        case .posts: return nil
        case .comments(postId: _): return nil
        case .users: return nil
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    // 7:
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    // 8:
    var sampleData: Data {
        return Data()
    }
    
    // 9:
    var task: Task {
        return .requestParameters(parameters: parameters ?? [String: Any](), encoding: parameterEncoding)
    }
}
