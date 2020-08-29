

import UIKit

class NewsArticles: UITableViewCell {

    @IBOutlet weak var ArticleImage: UIImageView!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var ArticleSection: UILabel!
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var BookmarkButton: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        Title.textContainer.maximumNumberOfLines = 3;
//        Title.textContainer.lineBreakMode = .byTruncatingTail;
        //Title.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
}
