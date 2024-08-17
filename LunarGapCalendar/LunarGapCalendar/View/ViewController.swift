//
//  ViewController.swift
//  LunarGapCalendar
//
//  Created by Gonca Seneroğlu on 1.08.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var lunaImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var userSurnameTextField: UITextField!
    @IBOutlet weak var welcomeUserNameLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleMainLabel(appNameLabel, font: UIFont(name: "HelveticaNeue-Bold", size: 24)!, textColor: UIColor.white, textAlignment: .center)
        styleMainLabel(welcomeUserNameLabel, font: UIFont(name: "HelveticaNeue-Bold", size: 24)!, textColor: UIColor.white, textAlignment: .center)
        styleMainTextField(userNameTextField, font:UIFont(name: "HelveticaNeue-Bold", size: 24)!, textColor: UIColor.white, textAlignment: .center)
        styleMainTextField(userSurnameTextField, font:UIFont(name: "HelveticaNeue-Bold", size: 24)!, textColor: UIColor.white, textAlignment: .center)
        if let userName = UserDefaults.standard.string(forKey: "Name"),
           let userSurname = UserDefaults.standard.string(forKey: "Surname") {
            userNameTextField.text = userName
            userSurnameTextField.text = userSurname
            welcomeUserNameLabel.isHidden = false
            welcomeUserNameLabel.text = "Hoşgeldin \(userName)"
            signInView.isHidden = true
        } else {
            welcomeUserNameLabel.isHidden = true
            userNameTextField.isHidden = true
            userSurnameTextField.isHidden = true
            
        }
        
        if let _ = UserDefaults.standard.string(forKey: "Name") {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(performSegueSecondView), userInfo: nil, repeats: false)
        }
    }
    
    
    
    @objc func performSegueSecondView() {
        performSegue(withIdentifier: "toSecondVC", sender: self)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        let userName = userNameTextField.text ?? ""
        let userSurname = userSurnameTextField.text ?? ""
        
        UserDefaults.standard.set(userName, forKey: "Name")
        UserDefaults.standard.set(userSurname, forKey: "Surname")
        
        welcomeUserNameLabel.text = "Hoşgeldin \(userName)"
        welcomeUserNameLabel.isHidden = false
        
        
        userNameTextField.isHidden = true
        userSurnameTextField.isHidden = true
        
        print("Kullanıcı bilgileri kaydedildi.")
        performSegue(withIdentifier: "toSecondVC", sender: nil)
        
    }
    
    func styleMainLabel(_ label: UILabel, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        
    }
    
    func styleMainTextField(_ textField: UITextField, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        textField.font = font
        textField.textColor = textColor
        textField.textAlignment = textAlignment
        
    }
}
