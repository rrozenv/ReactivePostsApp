
import Foundation
import UIKit
import SnapKit

final class PostTableCell: UITableViewCell, ValueCell {

    typealias Value = Post
    static var defaultReusableId: String = "PostTableCell"
    private var postView: PostView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupPostView()
    }
    
    func configureWith(value: Post) {
        postView.nameLabel.text = "User \(value.userId)"
        postView.replyBodyLabel.text = value.body
        postView.nameSubLabel.isHidden = true
    }
    
    private func setupPostView() {
        postView = PostView()
        
        contentView.addSubview(postView)
        postView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
}




