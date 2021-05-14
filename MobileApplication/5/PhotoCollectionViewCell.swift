//
//  PhotoCollectionViewCell.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!

    func set(_ image: UIImage?) {
        guard let image = image else {
            activityIndicator.startAnimating()
            return
        }
        imageView.image = image
        activityIndicator.stopAnimating()
    }
    
}
