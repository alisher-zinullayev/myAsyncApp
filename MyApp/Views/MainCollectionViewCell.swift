//
//  MainCollectionViewCell.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 17.08.2023.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MainCollectionViewCell.self)
    
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
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(backgroundPicture)
        backgroundPicture.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            backgroundPicture.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100),
            backgroundPicture.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundPicture.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundPicture.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: backgroundPicture.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundPicture.trailingAnchor, constant: -10),
            nameLabel.centerYAnchor.constraint(equalTo: backgroundPicture.centerYAnchor),
//            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
    
    func configure(label: String) {
        nameLabel.text = label
    }
}
