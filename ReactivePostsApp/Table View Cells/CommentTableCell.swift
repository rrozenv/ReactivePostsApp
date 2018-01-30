
import Foundation
import UIKit

final class CommentTableCell: UITableViewCell, ValueCell {
    
    typealias Value = Comment
    static var defaultReusableId: String = "CommentTableCell"
    private var commentView: PostView!
    
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
        setupCommentView()
    }
    
    func configureWith(value: Comment) {
        commentView.nameLabel.text = value.name
        commentView.replyBodyLabel.text = value.body
        commentView.nameSubLabel.text = value.email
    }
    
    private func setupCommentView() {
        commentView = PostView()
        
        contentView.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
}
