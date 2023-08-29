//
//  ViewController.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 17.08.2023.
//

import UIKit

final class MainViewController: UIViewController {

    let networkService = NetworkServiceWithAsync()
    var imageUrls: [URL] = []
    var imageNames: [String] = []
    var result: [Image] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private func setupBackgroundImage() {
        let backgroundImage = UIImageView(image: UIImage(named: "background_image"))
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        let cellSpacing: CGFloat = 30.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = 50
        let collectionViewBackgroundImage = UIImageView(image: UIImage(named: "background_image"))
        collectionViewBackgroundImage.contentMode = .scaleAspectFill
        collectionView.backgroundView = collectionViewBackgroundImage
        collectionView.backgroundColor = .red
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getDescriptions { descriptions in
            self.imageNames = descriptions
        }
        setupBackgroundImage()
        setupCollectionView()
        loadRandomImages()
        
    }
    
    func loadRandomImages() {
        Task {
            do {
                if let urls = try await networkService.fetchRandomImage(count: 10) {
                    imageUrls = urls
                    collectionView.reloadData()
                }
            } catch {
                print("Error fetching random images: \(error)")
            }
        }
    }
    
    private func fetchImage() {
        async {
            let networkService = NetworkServiceWithAsync()
            
            do {
                if let image = try await networkService.fetchImage(url: URL(string: "https://images.unsplash.com/photo-1692555052035-1a3116e30ba5?ixid=M3w0OTEzMzh8MHwxfGFsbHw5fHx8fHx8Mnx8MTY5MzEzMTU0MHw&ixlib=rb-4.0.3")!) {
                    print(image)
                }
            } catch {
                print("Error fetching random image URLs: \(error)")
            }
        }
    }
    
    private func fetchRandomImages() {
        async {
            let networkService = NetworkServiceWithAsync()

            do {
                if let imageURLs = try await networkService.fetchRandomImage(count: 10) {
                    for url in imageURLs {
                        print("Image URL: \(url)")
                    }
                }
            } catch {
                print("Error fetching random image URLs: \(error)")
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        let imageUrl = imageUrls[indexPath.row]
        var imageCell: String = ""
        Task {
            do {
                if let image = try await networkService.fetchImage(url: imageUrl) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            } catch {
                print("Error fetching image: \(error)")
            }
        }
        cell.configure(label: imageNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Cell at index \(indexPath.item) tapped")
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 2 * 30
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}
