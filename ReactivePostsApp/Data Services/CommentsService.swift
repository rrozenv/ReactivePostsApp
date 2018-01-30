
import Foundation
import RxSwift
import Moya
import RxMoya

struct CommentsService {
    
    private let provider = MoyaProvider<JSONPlaceholderAPI>()
    
    func fetchCommentsFor(postId: Int) -> Observable<[Comment]> {
        return provider.rx
            .request(.comments(postId: postId))
            .filter(statusCodes: 200...300).asObservable()
            .map([Comment].self)
    }
    
}
