//
//  BookViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

enum LoadingState {
    case loaded
    case loading
    case notLoaded
}

class BookViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var allBooks: [Book] = []
    private var images: [IndexPath : (LoadingState, UIImage?)] = [:]
    private var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }

    private func getBooks(with title: String) {
        images.removeAll()
        guard title.count >= 3,
              let url = URL(string: "https://api.itbook.store/1.0/search/\(title)") else {
            allBooks = []
            self.tableView.reloadData()
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
            guard let decoded = try? JSONDecoder().decode(Books.self, from: data) else {
                DispatchQueue.main.async {
                    self.present(LoadingError.loading)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                self.allBooks = decoded.list
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }

}

extension BookViewController {

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contoller = segue.destination as? DetailsBookViewController,
           let bookIndex = selectedIndexPath?.row {
            contoller.book = allBooks[bookIndex]
        } else {
            return
        }
    }

    
}

extension BookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        let book = allBooks[indexPath.row]

        switch images[indexPath]?.0 {
        case .loaded:
            cell.set(images[indexPath]?.1)
        case .loading:
            break
        case .notLoaded, nil:
            images[indexPath] = (.loading, nil)
            Thread {
                
                guard let url = URL(string: book.image),
                      let data = try? Data(contentsOf: url) else {
                    DispatchQueue.main.async {
                        self.images[indexPath] = (.loaded, UIImage(systemName: "book"))
                        if let cell = tableView.cellForRow(at: indexPath),
                           tableView.visibleCells.contains(cell) {
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.images[indexPath] = (.loaded, UIImage(data: data))
                    if let cell = tableView.cellForRow(at: indexPath),
                       tableView.visibleCells.contains(cell) {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    
                }

            }.start()
        }

        cell.set(allBooks[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            allBooks.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }


}

extension BookViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndexPath = indexPath
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension BookViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let searchText = searchBar.text else {
            allBooks = []
            self.tableView.reloadData()
            return
        }

        self.searchBar(searchBar, textDidChange: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getBooks(with: searchText.lowercased())
    }

}
