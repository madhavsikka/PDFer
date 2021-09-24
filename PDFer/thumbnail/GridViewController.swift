import UIKit

class GridViewController: UICollectionViewController {
    
    private let spacing: CGFloat = 10
    private let cellHeight: CGFloat = 250
    private let cellsPerRowPotrait: CGFloat = 4
    private let cellsPerRowLandscape: CGFloat = 6
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGridLayout()
    }
    
    private func configureGridLayout() {
        gridCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "pdfCell")
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.contentInsetAdjustmentBehavior = .always
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        gridCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pdfCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        let size = CGSize(width: safeFrame.width, height: safeFrame.height)
        return setCollectionViewItemSize(size: size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    
    func setCollectionViewItemSize(size: CGSize) -> CGSize {
        
        guard let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return CGSize(width: 0,height: 0) }
        
        if interfaceOrientation.isPortrait {
            let width = (size.width - (cellsPerRowPotrait - 1) * spacing) / cellsPerRowPotrait
            return CGSize(width: width, height: cellHeight)
        } else {
            let width = (size.width - (cellsPerRowLandscape - 1) * spacing) / cellsPerRowLandscape
            return CGSize(width: width, height: cellHeight)
        }
        
    }
}
