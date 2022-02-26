//
//  MarvelListViewController.swift
//  Task
//
//  Created by Rama Krishna on 23/02/22.
//

import UIKit
import MBProgressHUD

class MarvelListViewController: UIViewController {
    var marvelViewModel = MarvelViewModel()
    var marvelData: MarvelList?
    @IBOutlet weak var marvelListCollection: UICollectionView!
    @IBOutlet weak var searchView: UISearchBar!
    var searchedMovies: [String]?
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        marvelListCollection.delegate = self
        marvelListCollection.dataSource = self
        marvelListCollection.collectionViewLayout = UICollectionViewFlowLayout()
        marvelViewModel.delegate = self
        self.showHud()
        marvelViewModel.getMarvelListViewModel()
        self.searchView.showsCancelButton = false
        // Do any additional setup after loading the view.
    }

}

extension MarvelListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedMovies?.count ?? 0
        }
        else {
            return marvelViewModel.dataList?.search.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = marvelListCollection.dequeueReusableCell(withReuseIdentifier: "listCellID", for: indexPath)as? MarvelListCollectionViewCell
        if searching {
//            cell?.marvelNameLbl.text = searchedMovies?.search[indexPath.row].title
//            let url = URL(string: searchedMovies?.search[indexPath.row].poster ?? "")
//            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            cell?.marvelImage.image = UIImage(data: data!)
        }
        else {
            cell?.marvelNameLbl.text = marvelViewModel.dataList?.search[indexPath.row].title
            let url = URL(string: marvelViewModel.dataList?.search[indexPath.row].poster ?? "")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell?.marvelImage.image = UIImage(data: data!)
            cell?.contentView.layer.cornerRadius = 2.0
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.borderColor = UIColor.black.cgColor
            cell?.contentView.layer.masksToBounds = true
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarvelDetailsViewController")as? MarvelDetailsViewController
        detailViewController?.id = marvelViewModel.dataList?.search[indexPath.row].imdbID
        self.navigationController?.pushViewController(detailViewController!, animated: true)
    }
}

extension MarvelListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - 30) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension MarvelListViewController: GetMarvelListApiProtocol {
func getMarvelRequestApiSuccessfuly(results: MarvelList) {
    self.hideHUD()
    marvelViewModel.dataList = results
    DispatchQueue.main.async {
        self.marvelListCollection.reloadData()
    }
}

func getMarvelyRequestApiFailure(results: [String : AnyObject]) {
    
}

func getMarvelRequestConncetionFail(message: String) {
    
}

func getMarvelRequestSessionExpire(message: String) {
    
}
}

extension MarvelListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMovies = marvelViewModel.dataList?.search.filter{$0.title == searchText} as? [String]
        searching = true
        marvelListCollection.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchView.text = ""
        searchView.resignFirstResponder()
        marvelListCollection.reloadData()
        
    }
    
}
extension UIViewController {
    func showHud() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.isUserInteractionEnabled = false
    }

    func hideHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
