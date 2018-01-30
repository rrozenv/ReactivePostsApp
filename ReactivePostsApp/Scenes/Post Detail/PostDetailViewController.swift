
import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PostDetailViewController: UIViewController, BindableType {
    
    var viewModel: PostDetailViewModel!
    private let disposeBag = DisposeBag()
    private let dataSource = PostDetailDataSource()
    
    private var tableView: UITableView!
    private var backButton: UIBarButtonItem!
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        setupBackButton()
        setupTableView()
        setupActivityIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit { print("Post Detail VC deinit") }
    
    func bindViewModel() {
        
        //MARK: - Input
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        backButton.rx.tap.asObservable()
            .bind(to: viewModel.inputs.backButtonTappedInput)
            .disposed(by: disposeBag)
        
        //MARK: - Output
        viewModel.outputs.post
            .drive(onNext: { [weak self] in
                let section = PostDetailDataSource.Section.post.rawValue
                self?.dataSource.load(post: $0)
                self?.tableView.reloadSections([section], with: .none)
                self?.navigationItem.title = "POST \($0.id)"
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.comments
            .drive(onNext: { [weak self] in
                self?.dataSource.load(comments: $0)
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

extension PostDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = PostDetailDataSource.Section(rawValue: section) else { fatalError("Unexpected Section") }
        switch section {
        case .post: return sectionHeaderViewWith(title: "POST")
        case .comments: return sectionHeaderViewWith(title: "COMMENTS")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}

extension PostDetailViewController {
    
    private func sectionHeaderViewWith(title: String) -> UIView {
        let view = UIView()
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(20)
            make.centerY.equalTo(view.snp.centerY)
        }
        titleLabel.text = title
        return view
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension PostDetailViewController {
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.defaultReusableId)
        tableView.register(CommentTableCell.self, forCellReuseIdentifier: CommentTableCell.defaultReusableId)
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
    
    private func setupBackButton() {
        backButton = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(100)
        }
    }
    
}
