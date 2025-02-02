//
//  ViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Ahmet Hakan Asaroğlu on 15.01.2025.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { (autodataresult, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız, tekrar deneyin")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil )
                }
            }
            
            
        } else {
            self.hataMesaji(titleInput: "Hata", messageInput: "Email ve Parola Giriniz")
        }
        
        
        
        
        
        
        
    }
    
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            // kayıt olma islemi
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { (AuthDataResult, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız tekrar deneyin")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            hataMesaji(titleInput: "Hata", messageInput: "Email ve Parola Giriniz")
        }
        
        
    }
    
    
    func hataMesaji(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

