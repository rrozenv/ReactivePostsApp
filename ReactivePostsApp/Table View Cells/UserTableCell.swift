
import Foundation
import UIKit

final class UserTableCell: UITableViewCell, ValueCell {
    
    typealias Value = User
    static var defaultReusableId: String = "UserTableCell"
    private var userView: UserView!
    
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
    
    func configureWith(value: User) {
        userView.nameLabel.text = value.name
        userView.nameSubLabel.text = value.email
        userView.addressLabelOne.text = value.address.street
        userView.addressLabelTwo.text = value.address.city + " " + value.address.zipcode
    }
    
    private func setupCommentView() {
        userView = UserView()
        
        contentView.addSubview(userView)
        userView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
}
