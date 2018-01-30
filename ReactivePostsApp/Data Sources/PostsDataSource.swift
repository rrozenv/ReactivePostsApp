
import Foundation
import UIKit

final class PostsDataSource: ValueCellDataSource {
    
    func load(posts: [Post]) {
        self.set(values: posts,
                 cellClass: PostTableCell.self,
                 inSection: 0)
    }
    
    func post(at indexPath: IndexPath) -> Post? {
        return self[indexPath] as? Post
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as PostTableCell, value as Post):
            cell.configureWith(value: value)
        default:
            assertionFailure("Unrecognized combo: \(cell), \(value)")
        }
    }
    
}
