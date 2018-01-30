
import Foundation
import UIKit

protocol PostsRoutingLogic {
    func toPosts()
    func toPost(_ post: Post)
}

final class PostsRouter: PostsRoutingLogic {
    
    weak private var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toPosts() {
        var vc = PostsViewController()
        let viewModel = PostsViewModel(router: self)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toPost(_ post: Post) {
        var vc = PostDetailViewController()
        let router = PostDetailRouter(navigationController: navigationController!)
        let viewModel = PostDetailViewModel(post: post, router: router)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
