import UIKit

class GridCell2: UICollectionViewCell {
    
    static let identifier = "GridCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(with image: UIImage?) {
        if let safeImage = image {
            imageView.image = safeImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
