//
//  NewsCardView.swift
//  BlinkFeed
//
//  Created by Sparsh Pai on 2024-03-17.
//

import UIKit

class NewsCardView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with article: ArticleItem) {
        titleLabel.text = article.title
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        descriptionLabel.text = article.description
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        blurView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        
        sourceLabel.text = "Source: \(article.source.name)"
        sourceLabel.textColor = .lightGray
        sourceLabel.numberOfLines = 0
        sourceLabel.font = UIFont.systemFont(ofSize: 10)
        
        authorLabel.text = "Author: \(article.author ?? "Unkown")"
        authorLabel.textColor = .lightGray
        authorLabel.numberOfLines = 0
        authorLabel.font = UIFont.systemFont(ofSize: 10)
        
        if let imageUrl = article.urlToImage {
            loadImage(from: imageUrl)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func loadImage(from imageUrl: URL) {
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(named: "placeholder")
                }
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
}
