//
//  Post.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Ahmet Hakan Asaroğlu on 19.01.2025.
//

import Foundation


class Post {
    
    var email: String
    var yorum: String
    var gorselUrl: String
    
    init(email: String, yorum: String, gorselUrl: String) {
        self.email = email
        self.yorum = yorum
        self.gorselUrl = gorselUrl
    }
    
}


