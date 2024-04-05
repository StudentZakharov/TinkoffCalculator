

import UIKit

class CalculationsListViewController: UIViewController {
    
    var result: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    required init?(coder:NSCoder) {
        super.init(coder: coder)
        initialize()    }
    
    private func initialize(){
        modalPresentationStyle = .fullScreen
    }
    
    
    @IBOutlet weak var calculationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculationLabel.text = result
    }  
    
    
    
    @IBAction func dismissVC(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
