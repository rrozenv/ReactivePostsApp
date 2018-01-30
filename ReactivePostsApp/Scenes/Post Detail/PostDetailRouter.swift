
import Foundation
import UIKit

protocol PostDetailRoutingLogic {
    func toPosts()
}

final class PostDetailRouter: PostDetailRoutingLogic {
    
    weak private var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toPosts() {
        navigationController?.popViewController(animated: true)
    }
    
}
