import UIKit
import PDFKit

class DocumentViewController: UIViewController {
    
    let pdfView = PDFView()
    var pdfDocument: PDFDocument?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navigationBar: NavigationBar!
    
    private func configurePdfView() {
        pdfView.autoresizesSubviews = true
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
        pdfView.autoScales = true
        pdfView.highlightedSelections = [PDFSelection]()
    }
    
    override func viewDidLoad() {
        navigationBar.delegate = self
        configurePdfView()
        mainView.addSubview(pdfView)
        if let safePdfDocument = pdfDocument {
            pdfView.document = safePdfDocument
            pdfView.document?.delegate = self
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
        let GridViewController = storyBoard.instantiateViewController(withIdentifier: "GridViewController") as! GridViewController
        GridViewController.modalPresentationStyle = .fullScreen
        GridViewController.pdfView = pdfView
        present(GridViewController, animated: true, completion: nil)
    }
}
