import UIKit
import PDFKit

protocol GridViewControllerDelegate: AnyObject {
    func didPressGridCell(_ gridViewController: GridViewController, with index: Int)
}

class GridViewController: UICollectionViewController {
    
    static let identifier: String = "GridViewController"
    private let spacing: CGFloat = 8
    private let cellsPerRowPotrait: CGFloat = 4
    private let cellsPerRowLandscape: CGFloat = 6
    private var pageHeightToWidthRatio: CGFloat = 1
    
    weak var delegate: GridViewControllerDelegate?
    var pdfView: PDFView?
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGridLayout()
        configureGestures()
        let pageWidth = pdfView?.document?.page(at: 0)?.bounds(for: PDFDisplayBox.bleedBox).size.width
        let pageHeight = pdfView?.document?.page(at: 0)?.bounds(for: PDFDisplayBox.bleedBox).size.height
        if let safePageWidth = pageWidth, let safePageHeight = pageHeight {
            pageHeightToWidthRatio = safePageHeight / safePageWidth
        }
    }
    
    private func configureGridLayout() {
        gridCollectionView.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.contentInsetAdjustmentBehavior = .always
        gridCollectionView.frame = view.bounds
        let layout = UICollectionViewFlowLayout()
        gridCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func configureGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.gridCellLongPressed))
        self.gridCollectionView.addGestureRecognizer(longPress)
    }
    
    // Detect Long Presses on Grid Cell
    @objc private func gridCellLongPressed(sender : UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: collectionView)
            if let index = collectionView.indexPathForItem(at: touchPoint)?[1] {
                print(index)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let pageCount = pdfView?.document?.pageCount {
            return pageCount
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.identifier, for: indexPath) as! GridCell
        let cgSizeForCell = getCGSizeForCell()
        DispatchQueue.global(qos: .userInitiated).async {
            // Perform on background thread
            weak var pdfPage = self.pdfView?.document?.page(at: indexPath.item)
            let thumbnail = pdfPage?.thumbnail(of: cgSizeForCell, for: PDFDisplayBox.bleedBox)
            DispatchQueue.main.async {
                // Perform on main thread
                cell.configure(with: GridCellModel(image: thumbnail))
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didPressGridCell(self, with: indexPath.item)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getCGSizeForCell() -> CGSize {
        
        guard let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return CGSize(width: 0,height: 0) }
        
        // For Placing n cells per row
        // (n-1) inter item spacings are there between n cells, and 2 insets (one on left/right each)
        
        if interfaceOrientation.isLandscape {
            let widthPerCell = (view.frame.width - (cellsPerRowLandscape + 1) * spacing) / cellsPerRowLandscape
            return CGSize(width: widthPerCell, height: pageHeightToWidthRatio * widthPerCell)
        } else {
            let widthPerCell = (view.frame.width - (cellsPerRowPotrait + 1) * spacing) / cellsPerRowPotrait
            return CGSize(width: widthPerCell, height: pageHeightToWidthRatio * widthPerCell)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCGSizeForCell()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    
}
