import UIKit
class ViewController: UIViewController {
    //MARK: @IBOutlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var datePickerTF: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordConfirmationLabel: UILabel!
    @IBOutlet weak var registrationButtonPressed: UIButton!
    
    @IBOutlet weak var trashButton: UIButton!
    
    let datePicker = UIDatePicker()
    lazy var textFields: [UITextField] = {
        return [self.nameTextField, self.surNameTextField, self.datePickerTF, self.passwordTextField, self.passwordConfirmationTextField]
    }()

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsForDatePicker()
        customizatioButton()
        hiddenLabels()
        delegates()
    
        registrationButtonPressed.isEnabled = false
        trashButton.tintColor = .red
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndPrintText))
        view.addGestureRecognizer(tapGestureRecognizer)

   
        
        
    }

    func delegates() {
        nameTextField.delegate = self
        surNameTextField.delegate = self
        datePickerTF.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
    }
 


   

    
    
    
//MARK: Функции
    private func customizatioButton() {
        registrationButtonPressed.layer.cornerRadius = 10
        registrationButtonPressed.backgroundColor = .white
        registrationButtonPressed.layer.borderColor = UIColor.systemGray4.cgColor
        registrationButtonPressed.layer.borderWidth = 1
    }
    
    
    private func hiddenLabels() {
        nameLabel.isHidden = true
        surNameLabel.isHidden = true
        passwordLabel.isHidden = true
        passwordConfirmationLabel.isHidden = true
    }
    
    // CustomizingDatePicker
    private func settingsForDatePicker() {
        datePickerTF.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        let currentDate = Date()
        let minDate = Calendar.current.date(byAdding: .year, value: -99, to: currentDate)
        datePicker.maximumDate = currentDate
        datePicker.minimumDate = minDate

        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let emptyButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        
        toolBar.setItems([emptyButton,doneButton], animated: true)
        
        datePickerTF.inputAccessoryView = toolBar
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(tapFunc))
        self.view.addGestureRecognizer(tapped)
    }
    private func getDateFromPicker() {
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        datePickerTF.text = formater.string(from: datePicker.date)
    }
    
    
    private func nameValidationCheck() {
          guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

          if name.count < 2 || !name.hasPrefix(name.capitalized) {
              
              UtilityFunction().showAlert(vc: self, title: "Ошибка!", message: "Имя должно содержать не менее двух символов и начинаться с заглавной буквы")
              nameLabel.isHidden = false
              nameLabel.text = "Имя не соответствует требованиям!"
              nameLabel.textColor = .red
          } else {
              nameLabel.isHidden = false
              nameLabel.text = "Имя валидно!"
              nameLabel.textColor = .systemGreen
             // nameTextField.isEnabled = false
          }
        }
    
    private func surNameValidationCheck() {
        guard let surName = surNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if surName.count < 3 || !surName.hasPrefix(surName.capitalized) {
            UtilityFunction().showAlert(vc: self, title: "Ошибка!", message: "Фамилия должна содержать не менее трех символов и начинаться с заглавной буквы")
            
            surNameLabel.isHidden = false
            surNameLabel.text = "Фамилия не соответствует требованиям!"
            surNameLabel.textColor = .red
        } else {
            surNameLabel.isHidden = false
            surNameLabel.text = "Фамилия валидна!"
            surNameLabel.textColor = .systemGreen
                
        }

    }

    
    private func validityPasswordCheck() {
        let password = passwordTextField.text ?? ""
        if isValidPassword(password) {
            passwordLabel.isHidden = false
            passwordLabel.text = "Пароль подходит к заданным требованиям!"
            passwordLabel.textColor = .systemGreen
        } else {
            UtilityFunction().showAlert(vc: self, title: "Ошибка ввода пароля!", message: "Пароль должен содержать минимум 1 заглавную букву, 1 прописную букву и цифру")
            passwordLabel.isHidden = false
            passwordLabel.text = "Пароль не подходит к требованиям!"
            passwordLabel.textColor = .red
        }
    }
    
    
    private func passwordComparison() {
    
        let firstPassword = passwordTextField.text
        let secondPassword = passwordConfirmationTextField.text
        if firstPassword == secondPassword {
            validityPasswordCheck()
            registrationButtonPressed.isEnabled = false
            passwordConfirmationLabel.isHidden = false
            passwordConfirmationLabel.text = "Пароли совпадают"
            passwordConfirmationLabel.textColor = .systemGreen
            
        }else{
            validityPasswordCheck()
            UtilityFunction().showAlert(vc: self, title: "Ошибка!", message: "Пароли не совпадают")
            registrationButtonPressed.isEnabled = false
            passwordConfirmationLabel.isHidden = false
            passwordConfirmationLabel.text = "Пароли не совпадают"
            passwordConfirmationLabel.textColor = .red
            
        }
        
    }
    

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{3,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
  
    
    private func savingToStorage() {
        let text = nameTextField.text ?? ""
         let defaults = UserDefaults.standard
         defaults.set(text, forKey: "myTextFieldText")
         defaults.synchronize()
    }
    
    
    
    private func saveAndProceed() {
       UserDefaults.standard.set(true, forKey: "isRegistered")
            
       if let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
          let navigationController = UINavigationController(rootViewController: secondVC)
          navigationController.modalPresentationStyle = .fullScreen
          present(navigationController, animated: true, completion: nil)
       } else {
             print("ERROR TEST")
       }
    }
    
    
    private func updateButtonState() {
        let allFieldsFilled = !textFields.contains { $0.text?.isEmpty ?? true || $0.isEditing }
        registrationButtonPressed.isEnabled = allFieldsFilled
    }



    //MARK: Сишные Функции
    @objc func tapFunc() {
        view.endEditing(true)
    }
    @objc func dateChanged() {
        getDateFromPicker()
    }
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboardAndPrintText() {
        view.endEditing(true)
        if (nameTextField != nil) {
            nameValidationCheck()
        }
        
        if (surNameTextField != nil){
            surNameValidationCheck()
        }
        
        if (passwordTextField != nil){
            passwordComparison()
        }
        
        if (passwordConfirmationTextField != nil){
            validityPasswordCheck()
        }
    }
    

    
    
    //MARK: @IBAction
    @IBAction func registretionTappedButton(_ sender: UIButton) {
        savingToStorage()
        saveAndProceed()
    }
    
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        
        func alertClean(vc: UIViewController, title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okeyButton = UIAlertAction(title: "Да!", style: .default) { _ in
                self.nameTextField.text = ""
                self.nameLabel.text = ""
                self.surNameTextField.text = ""
                self.surNameLabel.text = ""
                self.datePickerTF.text = ""
                self.passwordTextField.text = ""
                self.passwordLabel.text = ""
                self.passwordConfirmationTextField.text = ""
                self.passwordConfirmationLabel.text = ""
                self.registrationButtonPressed.isEnabled = false
            }
            let cancelButton = UIAlertAction(title: "отмена", style: .cancel,handler: nil)

            alert.addAction(okeyButton)
            alert.addAction(cancelButton)
            vc.present(alert, animated: true, completion: nil)
        }
        alertClean(vc: self, title: "Вы хотите очистить все поля ввода?", message: "")
    }
}





//MARK: extension Delegate

extension ViewController: UITextFieldDelegate {
    
//переходит к следующему текст филду , после нажатия на Доне
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameValidationCheck()
            surNameTextField.becomeFirstResponder()

        case surNameTextField:
            surNameValidationCheck()
            datePickerTF.becomeFirstResponder()

        case datePickerTF:
        passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            validityPasswordCheck()
            passwordConfirmationTextField.becomeFirstResponder()
            
        case passwordConfirmationTextField:
            passwordComparison()
            passwordConfirmationTextField.resignFirstResponder()
        default:
            break
        }
        print("Done button pressed!")
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case nameTextField: updateButtonState()
        case surNameTextField: updateButtonState()
        case datePickerTF: return false
        case passwordTextField: updateButtonState()
        case passwordConfirmationTextField: updateButtonState()
        default:break
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButtonState()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
    }
}


    

