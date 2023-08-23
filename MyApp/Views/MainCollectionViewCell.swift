//
//  MainCollectionViewCell.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 17.08.2023.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MainCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backgroundPicture: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(backgroundPicture)
        backgroundPicture.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            backgroundPicture.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            backgroundPicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundPicture.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundPicture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: backgroundPicture.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundPicture.trailingAnchor, constant: -10),
            nameLabel.centerYAnchor.constraint(equalTo: backgroundPicture.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
    
    func configure(image: String, label: String) {
        imageView.image = UIImage(named: image)
        nameLabel.text = label
    }
}
