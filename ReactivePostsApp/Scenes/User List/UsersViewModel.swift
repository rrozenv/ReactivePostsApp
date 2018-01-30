
import Foundation
import RxSwift
import RxCocoa

protocol UsersViewModelInputs {
    var viewWillAppearInput: AnyObserver<Void> { get }
}

protocol UsersViewModelOutputs {
    var users: Driver<[User]> { get }
    var activityIndicator: Driver<Bool> { get }
    var errorTracker: Driver<Error> { get }
}

protocol UsersViewModelType {
    var inputs: UsersViewModelInputs { get }
    var outputs: UsersViewModelOutputs { get }
}

final class UsersViewModel: UsersViewModelType, UsersViewModelInputs, UsersViewModelOutputs {
    
//MARK: - Inputs
    var inputs: UsersViewModelInputs { return self }
    let viewWillAppearInput: AnyObserver<Void>
    
//MARK: - Outputs
    var outputs: UsersViewModelOutputs { return self }
    let users: Driver<[User]>
    let activityIndicator: Driver<Bool>
    let errorTracker: Driver<Error>
    
//MARK: - Init
    init(usersService: UsersService = UsersService()) {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        self.activityIndicator = activityIndicator.asDriver()
        self.errorTracker = errorTracker.asDriver()
        
        //MARK: - Subjects
        let _viewWillAppearInput = PublishSubject<Void>()
        
        //MARK: - Observers
        self.viewWillAppearInput = _viewWillAppearInput.asObserver()
        
        //MARK: - Source Observables
        let viewWillAppearObservable = _viewWillAppearInput.asObservable()
        
        //MARK: - Outputs
        self.users = viewWillAppearObservable
            .flatMapLatest {
                usersService.fetchAll()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
}
