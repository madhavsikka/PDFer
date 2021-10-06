import UIKit

protocol GridPopoverViewControllerDelegate: AnyObject {
    func didPressAddPageButton(_ gridPopoverViewController: GridPopoverViewController, with gridIndexPath: IndexPath?)
    func didPressDeletePageButton(_ gridPopoverViewController: GridPopoverViewController, with gridIndexPath: IndexPath?)
}

class GridPopoverViewController: UIViewController {
    
    static let identifier = "GridPopoverViewController"
    @IBOutlet weak var tableView: UITableView!
    var gridIndexPath: IndexPath?
    weak var delegate: GridPopoverViewControllerDelegate?
    
    let popoverOptions = [
        "Add a Page",
        "Delete this Page",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        preferredContentSize = CGSize(width: 200, height: 100)
    }
}

//MARK: - UITableViewDelegate

extension GridPopoverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            delegate?.didPressAddPageButton(self, with: gridIndexPath)
        case 1:
            delegate?.didPressDeletePageButton(self, with: gridIndexPath)
        default:
            return
        }
    }
    
}

//MARK: - UITableViewDataSource

extension GridPopoverViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popoverOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopoverCell", for: indexPath)
        cell.textLabel?.text = popoverOptions[indexPath.row]
        return cell
    }
}
