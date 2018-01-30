
import Foundation
import RxSwift
import RxCocoa

protocol PostsViewModelInputs {
    var viewWillAppearInput: AnyObserver<Void> { get }
    var postSelectedInput: AnyObserver<Post> { get }
}

protocol PostsViewModelOutputs {
    var posts: Driver<[Post]> { get }
    var activityIndicator: Driver<Bool> { get }
    var errorTracker: Driver<Error> { get }
}

protocol PostsViewModelType {
    var inputs: PostsViewModelInputs { get }
    var outputs: PostsViewModelOutputs { get }
}

final class PostsViewModel: PostsViewModelType, PostsViewModelInputs, PostsViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    
//MARK: - Inputs
    var inputs: PostsViewModelInputs { return self }
    let viewWillAppearInput: AnyObserver<Void>
    let postSelectedInput: AnyObserver<Post>
    
//MARK: - Outputs
    var outputs: PostsViewModelOutputs { return self }
    let posts: Driver<[Post]>
    let activityIndicator: Driver<Bool>
    let errorTracker: Driver<Error>
    
//MARK: - Init
    init(postsService: PostsService = PostsService(),
         router: PostsRoutingLogic) {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        self.activityIndicator = activityIndicator.asDriver()
        self.errorTracker = errorTracker.asDriver()
        
        //MARK: - Subjects
        let _viewWillAppearInput = PublishSubject<Void>()
        let _postSelectedInput = PublishSubject<Post>()
        
        //MARK: - Observers
        self.viewWillAppearInput = _viewWillAppearInput.asObserver()
        self.postSelectedInput = _postSelectedInput.asObserver()
        
        //MARK: - Source Observables
        let viewWillAppearObservable = _viewWillAppearInput.asObservable()
        let postSelectedObservable = _postSelectedInput.asObservable()
        
        //MARK: - Outputs
        self.posts = viewWillAppearObservable
            .flatMapLatest {
                postsService.fetchAll()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
            }
            .asDriver(onErrorJustReturn: [])
        
        //MARK: - Routing
        postSelectedObservable
            .do(onNext: router.toPost)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}



