//
//  ViewController.swift
//  BlinkFeed
//
//  Created by Sparsh Pai on 2024-03-16.
//

import UIKit
import Koloda

class MyNewsController: UIViewController {
    
    @IBOutlet weak var cardParentView: KolodaView!
    
    private let networkingManager = NetworkingManager()
    private var apiData: [ArticleItem] = []
    private var currentTopicsList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cardParentView.delegate = self
        cardParentView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if DataManager.shared.didChangeSelection {
            DataManager.shared.didChangeSelection = false
            self.apiData = []
            for keyword in DataManager.shared.selectedTopicsList {
                networkingManager.fetchDataFor(keyword:keyword) { result in
                    switch result {
                    case .success(let data):
                        var incomingData: [ArticleItem] = []
                        if let apiData = try? JSONDecoder().decode(Article.self, from: data) {
                            incomingData = apiData.articles.filter { articleItem in
                                guard let description = articleItem.description,
                                      let urlToImage = articleItem.urlToImage else {
                                    return false
                                }
                                
                                if description.count < 60 {
                                    return false
                                }
                                return true
                            }
                            
                            self.apiData.append(contentsOf: incomingData)
                            self.apiData.shuffle()
                            
                            DispatchQueue.main.async {
                                self.cardParentView.reloadData()
                                self.cardParentView.resetCurrentCardIndex()
                            }
                        
                        } else {
                            print("Failed to parse API data")
                        }
                    case .failure(let error):
                        print("Error fetching data: \(error)")
                    }
                }
            }
        }
    }
}

extension MyNewsController: KolodaViewDelegate, KolodaViewDataSource {
    func koloda(_ koloda: Koloda.KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = Bundle.main.loadNibNamed("NewsCardView", owner: self, options: nil)?.first as! NewsCardView
        
        if apiData.count > 0 {
            
            let articleItem = apiData[index]
            cardView.configure(with: articleItem)
            cardView.layer.cornerRadius = 10
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.5
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 4
            cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return cardView

    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return true
    }
    
    func kolodaNumberOfCards(_ koloda: Koloda.KolodaView) -> Int {
        self.apiData.count
    }
    
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        0.2
    }
}