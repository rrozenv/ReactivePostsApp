
import Foundation
import UIKit

protocol UsersRoutingLogic {
    func toUsers()
}

final class UsersRouter: UsersRoutingLogic {
    
    weak private var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toUsers() {
        var vc = UsersViewController()
        let viewModel = UsersViewModel()
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
