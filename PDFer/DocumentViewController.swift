import UIKit
import PDFKit

class DocumentViewController: UIViewController {
    
    let pdfView = PDFView()
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navigationBar: NavigationBar!
    
    override func viewDidLoad() {
        navigationBar.delegate = self
        configurePdfView()
        configurePdfViewGestures()
        mainView.addSubview(pdfView)
    }
    
    private func configurePdfView() {
        pdfView.autoresizesSubviews = true
        // pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
        pdfView.autoScales = false
        pdfView.clipsToBounds = true
        pdfView.highlightedSelections = [PDFSelection]()
    }
    
    private func configurePdfViewGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.pdfViewTapped))
        singleTap.numberOfTouchesRequired = 1
        singleTap.numberOfTapsRequired = 1
        self.pdfView.addGestureRecognizer(singleTap)
    }
    
    @objc func pdfViewTapped(sender : UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended) {
            navigationBar.toggleVisibility()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//MARK: - PDFDocumentDelegate

extension DocumentViewController: PDFDocumentDelegate {
    func didMatchString(_ selection: PDFSelection) {
        selection.color = .yellow
        pdfView.highlightedSelections?.append(selection)
    }
}

//MARK: - NavigationBarDelegate

extension DocumentViewController: NavigationBarDelegate {
    
    func didChangeTextField(_ navigationBar: NavigationBar, toSearch text: String?) {
        guard let safeText = text else { return }
        pdfView.document?.cancelFindString()
        pdfView.highlightedSelections = [PDFSelection]()
        pdfView.document?.delegate = self
        pdfView.document?.beginFindString(safeText, withOptions: .caseInsensitive)
    }
    
    func didPressBackButton(_ navigationBar: NavigationBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didPressGridButton(_ navigationBar: NavigationBar) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let gridViewController = storyBoard.instantiateViewController(withIdentifier: GridViewController.identifier) as! GridViewController
        gridViewController.modalPresentationStyle = .fullScreen
        gridViewController.pdfView = pdfView
        gridViewController.delegate = self
        present(gridViewController, animated: true, completion: nil)
    }
}

//MARK: - GridViewControllerDelegate

extension DocumentViewController: GridViewControllerDelegate {
    
    func didPressGridCell(_ gridViewController: GridViewController, with index: Int) {
        if let targetPdfPage = pdfView.document?.page(at: index) {
            pdfView.go(to: targetPdfPage)
        }
    }
    
}
