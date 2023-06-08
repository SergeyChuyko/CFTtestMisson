import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabelDVC: UILabel!
    @IBOutlet weak var dateLabelDVC: UILabel!
    
    var labelText1: String?
    var labelText2: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabelDVC.text = labelText1
        dateLabelDVC.text = labelText2
    }

    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
 
}
