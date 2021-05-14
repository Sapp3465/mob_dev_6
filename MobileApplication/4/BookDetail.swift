//
//  BookDetail.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import Foundation

struct BookDetail: Decodable {
    
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    
    let isbn13: String
    let price: String
    let image: String

}
