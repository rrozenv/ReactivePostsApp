
import Foundation
import UIKit

final class UserView: UIView {
    
    var userImageView: UIImageView!
    var nameLabel: UILabel!
    var nameSubLabel: UILabel!
    var addressLabelOne: UILabel!
    var addressLabelTwo: UILabel!
    private var addressStackView: UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setupAddressLabelsStackView()
        setupUserImageView()
        setupNameLabelsStackView()
    }
    
    private func setupAddressLabelsStackView() {
        addressLabelOne = UILabel()
        addressLabelOne.textColor = UIColor.black
        addressLabelOne.numberOfLines = 1
        addressLabelOne.font = FontBook.AvenirHeavy.of(size: 13)
        
        addressLabelTwo = UILabel()
        addressLabelTwo.textColor = UIColor.gray
        addressLabelTwo.numberOfLines = 1
        addressLabelTwo.font = FontBook.AvenirMedium.of(size: 12)
        
        let views: [UILabel] = [addressLabelOne, addressLabelTwo]
        addressStackView = UIStackView(arrangedSubviews: views)
        addressStackView.spacing = 2.0
        addressStackView.axis = .vertical
        
        self.addSubview(addressStackView)
        addressStackView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.bottom.equalTo(self.snp.bottom).offset(-17)
        }
    }
    
    private func setupUserImageView() {
        userImageView = UIImageView()
        userImageView.layer.cornerRadius = 36/2
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = UIColor.lightGray
        
        self.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(20)
            make.top.equalTo(self.snp.top).offset(17)
            make.bottom.equalTo(addressStackView.snp.top).offset(-17)
            make.height.width.equalTo(36)
        }
    }
    
    private func setupNameLabelsStackView() {
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 1
        nameLabel.font = FontBook.AvenirHeavy.of(size: 13)
        
        nameSubLabel = UILabel()
        nameSubLabel.textColor = UIColor.gray
        nameSubLabel.numberOfLines = 1
        nameSubLabel.font = FontBook.AvenirMedium.of(size: 12)
        
        let views: [UILabel] = [nameLabel, nameSubLabel]
        let labelsStackView = UIStackView(arrangedSubviews: views)
        labelsStackView.spacing = 2.0
        labelsStackView.axis = .vertical
        
        self.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImageView.snp.centerY)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self.snp.right).offset(-20)
        }
    }
    
}
