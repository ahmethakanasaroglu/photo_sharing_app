//
//  UploadViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Ahmet Hakan Asaroğlu on 15.01.2025.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    

    @objc func gorselSec() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // any' i uiimage'a cast etmek lazım
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func uploadButtonTiklandi(_ sender: Any) {
        let storage = Storage.storage()   // depolama islemi
        let storageReference = storage.reference()   // konum belirtir. oldugun dosyanın, dizinin konumu
        
        let mediaFolder = storageReference.child("media")   // bir yapının alt klasörüne geçerken child kullanırız.
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) { // görsel storage'ye imageview olarak kayıt edilemez biz de dönüştürme yapıyoruz. 0.5 sıkıştırma derecesi verdik.
            
            let uuid = UUID().uuidString  // her defasında rastgele olusturulmus uuidString olusturur.
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (StorageMetadata, error) in
                if error != nil {
                    self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız Tekrar Deneyiniz!")
                } else {
                    imageReference.downloadURL { (url, error) in  // indirilen url'yi bilmemiz gerek ki nereye gittigini bilelim
                        if error == nil {   // yani error yoksa
                            let imageUrl = url?.absoluteString   // kesinlikle string'e cevircek
                            
                            if let imageUrl = imageUrl {  // opsiyonel olmayan bir imageUrl oluyor burada artık
                                
                                let firestoreDatabase = Firestore.firestore()
                                 
                                let firestorePost = ["gorselurl": imageUrl, "yorum": self.yorumTextField.text, "email": Auth.auth().currentUser!.email, "tarih": FieldValue.serverTimestamp() ] // dictionary'i olusturuyoruz
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { (error) in
                                    if error != nil {
                                        self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız, tekrar deneyin.. ")
                                    } else {
                                        
                                        self.imageView.image = UIImage(named: "gorselsec")
                                        self.yorumTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0  // 0-1-2 diye gidiyor indeksler tabBar'da
                                        
                                        
                                        
                                    }
                                }
                                
                                
                                
                                
                            }
                            
                            
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    
    func hataMesajiGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    

}
