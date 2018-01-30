
import Foundation
import UIKit

final class PostDetailDataSource: ValueCellDataSource {
    
    enum Section: Int {
        case post
        case comments
    }
    
    func load(post: Post) {
        self.set(values: [post],
                 cellClass: PostTableCell.self,
                 inSection: Section.post.rawValue)
    }
    
    func load(comments: [Comment]) {
        self.set(values: comments,
                 cellClass: CommentTableCell.self,
                 inSection: Section.comments.rawValue)
    }
    
    func comment(at indexPath: IndexPath) -> Comment? {
        return self[indexPath] as? Comment
    }
    
    func post(at indexPath: IndexPath) -> Post? {
        return self[indexPath] as? Post
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as PostTableCell, value as Post):
            cell.configureWith(value: value)
        case let (cell as CommentTableCell, value as Comment):
            cell.configureWith(value: value)
        default:
            assertionFailure("Unrecognized combo: \(cell), \(value)")
        }
    }
    
}
