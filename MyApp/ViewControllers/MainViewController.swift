//
//  ViewController.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 17.08.2023.
//

import UIKit

class MainViewController: UIViewController {

    var result: [Image] = []
    var tempString: String = ""
    private let images: [String] = ["image1", "image1", "image1", "image1", "image1"]
    private let imageNames: [String] = ["We love travelling around the world", "Romance Stories", "iOS Dev", "Race", "Personal Development"]
    
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
        setupBackgroundImage()
        setupCollectionView()
        Task.init { [weak self] in
            do {
                let images = try await NetworkServiceWithAsync.shared.fetchData()
                DispatchQueue.main.async {
                    self?.result = images
                    self?.collectionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private var adapterList = [UICollectionViewCell: ReusableCellImageAdapter]()

    private func getReusableAdapter(forReusableCell cell: UICollectionViewCell) -> ReusableCellImageAdapter{
        if let adapter = adapterList[cell]{
            print("Find a reusable adapter")
            return adapter
        }
        else{
            print("Create a reusable adapter")
            let adapter = ReusableCellImageAdapter()
            adapterList[cell] = adapter
            return adapter
        }
    }
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
//        let filename = "\(indexPath.row).jpg"
//        let baseUrl = "https://your.url.com/images/"
//        let path = baseUrl + filename
        let path = "https://images.unsplash.com/photo-1691512935129-5ab21146a1bc?ixid=M3w0OTEzMzh8MHwxfGFsbHwyfHx8fHx8Mnx8MTY5MjcwNTU0MHw&ixlib=rb-4.0.3"
        let adapter = getReusableAdapter(forReusableCell: cell)
        cell.imageView.image = nil
        cell.imageView.backgroundColor = .systemBlue
        cell.imageView.startAnimating()
        adapter.configure(from: path) { image in
            cell.imageView.stopAnimating()
            if let image = image {
                cell.imageView.image = image
            }
            else{
                cell.imageView.backgroundColor = .systemRed
            }
        }
        
//        let item = result[indexPath.row]
        
//        cell.configure(image: item.urls.raw, label: item.description ?? "asdasdad")
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
