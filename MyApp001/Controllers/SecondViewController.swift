import UIKit
class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var greetingButton: UIButton!
    
    var competitions: [Competition] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        displayCompetitions()
        uiSetting()
    }

//MARK: Функции
    private func uiSetting () {
        greetingButton.layer.borderColor = UIColor.black.cgColor
        greetingButton.layer.borderWidth = 1
        greetingButton.layer.cornerRadius = 10
        
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
    }

    private func displayCompetitions() {
        guard let url = URL(string: API) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let competitions = try JSONDecoder().decode([Competition].self, from: data)
                DispatchQueue.main.async {
                    self.competitions = competitions
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

//MARK: @IBAction
    @IBAction func greetingButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let savedText = defaults.string(forKey: "myTextFieldText")
        
        if let savedText = savedText {
            UtilityFunction().showAlert(vc: self, title: "Приветствую \(savedText)", message: "")
        } else {
            return
        }
    }
    
 



    
  
}

//MARK: extension DataSourse
extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CompetitionTableViewCell
        let competition = competitions[indexPath.row]
        cell.nameLabel.text = competition.name
        cell.dateLabel.text = "\(competition.startTime) - \(competition.endTime)"
 
        return cell
    }
}


//MARK: extension Delegate
extension SecondViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! CompetitionTableViewCell
        let labelText1 = cell.nameLabel.text
        let labelText2 = cell.dateLabel.text

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.labelText1 = labelText1
         detailViewController.labelText2 = labelText2

        detailViewController.modalPresentationStyle = .fullScreen
         self.present(detailViewController, animated: true, completion: nil)
        
    }
}



