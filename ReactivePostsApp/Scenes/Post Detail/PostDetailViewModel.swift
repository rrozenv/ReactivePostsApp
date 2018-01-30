
import Foundation
import RxSwift
import RxCocoa

protocol PostDetailViewModelInputs {
    var backButtonTappedInput: AnyObserver<Void> { get }
}

protocol PostDetailViewModelOutputs {
    var post: Driver<Post> { get }
    var comments: Driver<[Comment]> { get }
    var activityIndicator: Driver<Bool> { get }
    var errorTracker: Driver<Error> { get }
}

protocol PostDetailViewModelType {
    var inputs: PostDetailViewModelInputs { get }
    var outputs: PostDetailViewModelOutputs { get }
}

final class PostDetailViewModel: PostDetailViewModelType, PostDetailViewModelInputs, PostDetailViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    
//MARK: - Inputs
    var inputs: PostDetailViewModelInputs { return self }
    let backButtonTappedInput: AnyObserver<Void>
    
//MARK: - Outputs
    var outputs: PostDetailViewModelOutputs { return self }
    let post: Driver<Post>
    let comments: Driver<[Comment]>
    let activityIndicator: Driver<Bool>
    let errorTracker: Driver<Error>
    
//MARK: - Init
    init(post: Post,
         commentsService: CommentsService = CommentsService(),
         router: PostDetailRoutingLogic) {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        self.activityIndicator = activityIndicator.asDriver()
        self.errorTracker = errorTracker.asDriver()
        
        //MARK: - Subjects
        let _backButtonTappedInput = PublishSubject<Void>()
        
        //MARK: - Observers
        self.backButtonTappedInput = _backButtonTappedInput.asObserver()
        
        //MARK: - Source Observables
        let backButtonTappedObservable = _backButtonTappedInput.asObservable()
        
        //MARK: - Outputs
        self.comments = Observable.of(post)
            .flatMapLatest {
                commentsService.fetchCommentsFor(postId: $0.id)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
            }
            .asDriver(onErrorJustReturn: [])
        
        self.post = Driver.of(post)
        
        //MARK: - Routing
        backButtonTappedObservable
            .do(onNext: router.toPosts)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
