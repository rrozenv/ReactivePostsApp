
import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PostsViewController: UIViewController, BindableType {
    
    var viewModel: PostsViewModel!
    private let disposeBag = DisposeBag()
    private let dataSource = PostsDataSource()
    
    private var tableView: UITableView!
    private var createReplyButton: UIBarButtonItem!
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        setupTableView()
        setupActivityIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "POSTS"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppearInput.onNext(())
    }
    
    func bindViewModel() {
        
        //MARK: - Input
        tableView.rx.itemSelected.asObservable()
            .map { [unowned self] in self.dataSource.post(at: $0)! }
            .bind(to: viewModel.inputs.postSelectedInput)
            .disposed(by: disposeBag)
  
        //MARK: - Output
        viewModel.outputs.posts
            .drive(onNext: { [weak self] in
                self?.dataSource.load(posts: $0)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.activityIndicator
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorTracker
            .drive(onNext: { [weak self] in
                self?.showError($0)
            })
            .disposed(by: disposeBag)
    }
    
}

//MARK: - Error Handling
extension PostsViewController {
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - View Configuration
extension PostsViewController {
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.defaultReusableId)
        tableView.estimatedRowHeight = 200
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
        }
    }
    
}
