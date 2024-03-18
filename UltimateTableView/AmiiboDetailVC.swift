//
//  AmiiboDetailVC.swift
//  UltimateTableView
//
//  Created by Зайнал Гереев on 03.04.2022.
//

import UIKit

class AmiiboDetailVC: UIViewController {
    var amiibo: AmiiboForView?
    
    var safeArea: UILayoutGuide!
    let imageView = CustomImageView()
    let nameLabel = UILabel()
    
    let dismissButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        safeArea = view.safeAreaLayoutGuide
        
        setupImage()
        setupData()
        setupNameLabel()
        setupDismissButtin()
    }
    
    func setupImage() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50).isActive = true
        imageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
    }
    
    func setupNameLabel() {
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        nameLabel.textColor = .white
    }
    
    func setupDismissButtin() {
        view.addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -50).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        
        dismissButton.setTitle("Dismiss", for: .normal)

        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    func setupData() {
        if let amiibo = amiibo,
           let url = URL(string: amiibo.imageUrl)
        {
            imageView.loadImage(from: url)
            nameLabel.text = amiibo.name
        }
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true)
    }
    
}
