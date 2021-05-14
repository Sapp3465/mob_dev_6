//
//  CollectionViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var collcetionView: UICollectionView!
    private var pictures: [UIImage?] = (0..<24).map { _ in nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collcetionView.delegate = self
        collcetionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImages()
    }
    
    func loadImages() {
        self.activityIndicator.startAnimating()
        guard var components = URLComponents(string: "https://pixabay.com/api/") else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.present(LoadingError.loading)
            }
            return
        }
        let queryItems = [URLQueryItem(name: "key", value: "19193969-87191e5db266905fe8936d565"),
                          .init(name: "q", value: "hot+summer"),
                          .init(name: "image_type", value: "photo"),
                          .init(name: "per_page", value: "24")]
        components.queryItems = queryItems
        guard let url = components.url else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.present(LoadingError.loading)
            }
            return
        }
        struct Wrapper: Decodable {
            struct ImageInfo: Decodable {
                let largeImageURL: String
            }
            let hits: [ImageInfo]
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, _, _) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.present(LoadingError.loading)
                }
                return
            }
            guard let decoded = try? JSONDecoder().decode(Wrapper.self, from: data) else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.present(LoadingError.loading)
                }
                return
            }
            DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            }
            DispatchQueue.concurrentPerform(iterations: decoded.hits.count) { (index) in
                guard let url = URL(string: decoded.hits[index].largeImageURL),
                      let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.present(LoadingError.loading)
                        self.pictures[index] = UIImage()
                        self.collcetionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.pictures[index] = UIImage(data: data)
                    self.collcetionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }.resume()
        
    }


}
extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.set(pictures[indexPath.row])
        return cell
    }

}
