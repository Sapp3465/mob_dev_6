//
//  DetailsBookViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class DetailsBookViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookSubtitle: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookPublisher: UILabel!
    @IBOutlet weak var bookPages: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    @IBOutlet weak var bookRating: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var book: Book?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookDetail()
    }

    private func loadBookDetail() {
        guard let book = book else {
            return
        }
        guard let url = URL(string: "https://api.itbook.store/1.0/books/\(book.isbn13)") else {
            return
        }
        
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, _, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.present(LoadingError.loading)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            guard let decoded = try? JSONDecoder().decode(BookDetail.self, from: data) else {
                DispatchQueue.main.async {
                    self.present(LoadingError.loading)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                self.installViews(with: decoded)
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
    private func installViews(with book: BookDetail) {
        
        if let url = URL(string: book.image) {
            Thread {
                guard let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.bookImage.image = UIImage(systemName: "book")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.bookImage.image = UIImage(data: data)
                }
            }.start()

        }
        bookTitle.attributedText = label(with: "Title: ", content: book.title)
        bookSubtitle.attributedText = label(with: "Subtitle: ", content: book.subtitle)
        bookDescription.attributedText = label(with: "Description: ", content: book.desc)
        bookAuthor.attributedText = label(with: "Author: ", content: book.authors)
        bookPublisher.attributedText = label(with: "Publisher: ", content: book.publisher)
        bookPages.attributedText = label(with: "Pages: ", content: book.pages)
        bookYear.attributedText = label(with: "Year: ", content: book.year)
        bookRating.attributedText = label(with: "Rating: ", content: book.rating)
    }


    private func label(with title: String, content: String) -> NSMutableAttributedString {
        
        let firstString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let secondString = NSAttributedString(string: content, attributes: [:])

        firstString.append(secondString)

        return firstString
    }

}
