import UIKit

protocol NavigationBarDelegate: AnyObject {
    func didPressBackButton(_ navigationBar: NavigationBar)
    func didPressGridButton(_ navigationBar: NavigationBar)
    func didChangeTextField(_ navigationBar: NavigationBar, toSearch text: String?)
}

class NavigationBar: UIView {
    
    weak var delegate: NavigationBarDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var gridButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureTextField()
        configureSearchButton()
    }
    
    func configureSearchButton() {
        searchButton.backgroundColor = .clear
        searchButton.layer.cornerRadius = 5
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    }
    
    func configureTextField() {
        textField.isHidden = true
        textField.borderStyle = .roundedRect
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftViewMode = .always
    }
    
    func toggleVisibility() {
        if(!self.isHidden) {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (finished) in
                self.isHidden = finished
            }
        } else {
            self.alpha = 0
            self.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        UIView.transition(with: self.textField, duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.textField.isHidden = !self.textField.isHidden
                          })
        
        if searchButton.backgroundColor == .white {
            searchButton.backgroundColor = .clear
            searchButton.tintColor = .white
        } else {
            searchButton.backgroundColor = .white
            searchButton.tintColor = .black
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        delegate?.didPressBackButton(self)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        delegate?.didChangeTextField(self, toSearch: sender.text)
    }
    
    @IBAction func gridButtonPressed(_ sender: UIButton) {
        delegate?.didPressGridButton(self)
    }
}
