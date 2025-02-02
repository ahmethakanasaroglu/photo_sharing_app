//
//  FeedViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Ahmet Hakan Asaroğlu on 15.01.2025.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postDizisi = [Post]()
    
    /*
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVerileriAl()
    }
    
    
    func firebaseVerileriAl() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true).addSnapshotListener { (snapshot, error) in // tarihe göre sıralar. son atılanları güncel tutar.
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {     // boş degilse gelen deger yani
                    
                    //self.emailDizisi.removeAll(keepingCapacity: false)
                    //self.yorumDizisi.removeAll(keepingCapacity: false)
                    //self.gorselDizisi.removeAll(keepingCapacity: false)
                    
                    self.postDizisi.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {   // dokümanlara dizin içinde döngü içinde erişiriz
                        // let documentId = document.documentID   // doküman ID lazımsa bunu yapabiliyoruz
                        if let gorselUrl = document.get("gorselurl") as? String  {    // get -> Any optional döndürür, cast ediyoruz stringe
                            
                            if let yorum = document.get("yorum") as? String {
                                
                                if let email = document.get("email") as? String {
                                    
                                    let post = Post(email: email, yorum: yorum, gorselUrl: gorselUrl)
                                    self.postDizisi.append(post)
                                    
                                }
                            }
                        }
                        
                        
                        
                        
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDizisi.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell // tekrar kullanılabilir hücre ;  olusturdugumuz FeedCell sınıfına cast etmemiz gerekiyor
        cell.emailText.text = postDizisi[indexPath.row].email
        cell.yorumText.text = postDizisi[indexPath.row].yorum
        cell.postImageView.sd_setImage(with: URL(string: self.postDizisi[indexPath.row].gorselUrl))  // bu stringler url'ye cevrilip indirilecektir
        return cell
    }

}
