//
//  MarvelDetailsViewController.swift
//  Task
//
//  Created by Rama Krishna on 23/02/22.
//

import UIKit

class MarvelDetailsViewController: UIViewController {
    var marvelDetailsViewModel = MarvelDetailsViewModel()
    var marvelDetailsData: MarvelDetails?
    var id: String?
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var posterYear: UILabel!
    @IBOutlet weak var movieTime: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var popularityLbl: UILabel!
    @IBOutlet weak var scoreRate: UILabel!
    @IBOutlet weak var votesValLbl: UILabel!
    @IBOutlet weak var popularityValLbl: UILabel!
    @IBOutlet weak var categorylbl: UILabel!
    @IBOutlet weak var directorlbl: UILabel!
    @IBOutlet weak var writerLvl: UILabel!
    @IBOutlet weak var actorsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        marvelDetailsViewModel.delegate = self
        self.showHud()
        marvelDetailsViewModel.getMarvelListViewModel(id: id ?? "")
        // Do any additional setup after loading the view.
    }
    
    func dataAssign () {
        let url = URL(string: marvelDetailsViewModel.dataList?.poster ?? "")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        DispatchQueue.main.async {
            self.posterImg.image = UIImage(data: data!)
            self.posterName.text = self.marvelDetailsViewModel.dataList?.title
            self.posterYear.text = self.marvelDetailsViewModel.dataList?.released
            self.movieTime.text = self.marvelDetailsViewModel.dataList?.runtime
            self.movieRating.text = self.marvelDetailsViewModel.dataList?.imdbRating
            self.stringType(type: "Synopsis: ", data: self.marvelDetailsViewModel.dataList!.plot, lblText: self.synopsis)
            let height = self.heightForView(text: self.marvelDetailsViewModel.dataList!.plot, width: 100.0)
            self.synopsis.frame = CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: height)
            self.scoreRate.text = self.marvelDetailsViewModel.dataList?.imdbRating
            self.votesValLbl.text = self.marvelDetailsViewModel.dataList?.imdbVotes
            self.popularityValLbl.text = self.marvelDetailsViewModel.dataList?.metascore
            self.categorylbl.text = self.marvelDetailsViewModel.dataList?.genre
            self.stringType(type: "Director: ", data: self.marvelDetailsViewModel.dataList?.director ?? "", lblText: self.directorlbl)
            self.stringType(type: "Writer: ", data: self.marvelDetailsViewModel.dataList?.writer ?? "", lblText: self.writerLvl)
            self.stringType(type: "Actor: ", data: self.marvelDetailsViewModel.dataList?.actors ?? "", lblText: self.actorsLbl)

        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func stringType(type: String, data: String, lblText: UILabel) {
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]

        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black]

        let attributedString1 = NSMutableAttributedString(string:type, attributes:attrs1)

        let attributedString2 = NSMutableAttributedString(string:data, attributes:attrs2)

        attributedString1.append(attributedString2)
        lblText.attributedText = attributedString1
    }
    
    func heightForView(text:String, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.text = text

       label.sizeToFit()
       return label.frame.height
   }

    
}



extension MarvelDetailsViewController: GetMarvelDetailsApiProtocol {
    func getMarvelDetailRequestApiSuccessfuly(results: MarvelDetails) {
        self.hideHUD()
        marvelDetailsViewModel.dataList = results
        dataAssign()
    }
    
    func getMarvelDetailRequestApiFailure(results: [String : AnyObject]) {
        
    }
    
    func getMarvelDetailRequestConncetionFail(message: String) {
        
    }
    
    func getMarvelDetailRequestSessionExpire(message: String) {
        
    }
    
    
}
