//
//  BookTableViewCell.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var bookTitleLabel: UILabel!
    @IBOutlet private weak var bookSubtitleLabel: UILabel!
    @IBOutlet private weak var bookPriceLabel: UILabel!
    
    func set(_ book: Book) {
        bookTitleLabel.text = book.title
        bookSubtitleLabel.text = book.subtitle
        bookPriceLabel.text = book.price
    }

    func set(_ image: UIImage?) {
        bookImageView.image = image
    }

}
