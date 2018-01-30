
import Foundation
import RxSwift
import Moya
import RxMoya

struct PostsService {
    
    private let provider = MoyaProvider<JSONPlaceholderAPI>()
    private let cache: Cache = Cache<Post>(path: "posts")

    func fetchAll() -> Observable<[Post]> {
        let cachedPosts = cache.fetchObjects().asObservable()
        let networkPosts = provider.rx
            .request(.posts)
            .filter(statusCodes: 200...300).asObservable()
            .map([Post].self)
            .flatMap {
                return self.cache.save(objects: $0)
                    .asObservable()
                    .map(to: [Post].self)
                    .concat(Observable.just($0))
            }
        return cachedPosts.concat(networkPosts)
    }
    
}

struct MapFromNever: Error {}
extension ObservableType where E == Never {
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}

