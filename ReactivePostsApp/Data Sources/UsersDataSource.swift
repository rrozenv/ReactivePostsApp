
import Foundation
import UIKit

final class UsersDataSource: ValueCellDataSource {
    
    func load(users: [User]) {
        self.set(values: users,
                 cellClass: UserTableCell.self,
                 inSection: 0)
    }
    
    func post(at indexPath: IndexPath) -> User? {
        return self[indexPath] as? User
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as UserTableCell, value as User):
            cell.configureWith(value: value)
        default:
            assertionFailure("Unrecognized combo: \(cell), \(value)")
        }
    }
    
}
