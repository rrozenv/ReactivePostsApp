
import Foundation
import RxSwift
import Moya
import RxMoya

struct UsersService {
    
    private let provider = MoyaProvider<JSONPlaceholderAPI>()
    private let cache: Cache = Cache<User>(path: "users")
    
    func fetchAll() -> Observable<[User]> {
        let cachedUsers = cache.fetchObjects().asObservable()
        let networkUsers = provider.rx
            .request(.users)
            .filter(statusCodes: 200...300).asObservable()
            .map([User].self)
            .flatMap {
                return self.cache.save(objects: $0)
                    .asObservable()
                    .map(to: [User].self)
                    .concat(Observable.just($0))
        }
        return cachedUsers.concat(networkUsers)
    }
    
}
