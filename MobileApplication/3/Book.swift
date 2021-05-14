//
//  Book.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import Foundation

struct Books: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case list = "books"
    }

    let list: [Book]

}

struct Book: Decodable {
    
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    
}
