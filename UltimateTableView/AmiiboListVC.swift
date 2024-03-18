//
//  ViewController.swift
//  UltimateTableView
//
//  Created by Зайнал Гереев on 01.04.2022.
//

import UIKit

class AmiiboListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var amiiboList = [AmiiboForView]()

    
    override func viewDidLoad() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupView()
        
        //что происходит?? распарсили запрос через AmiiboAPI и передали их в AbmiiboForCell?
        AmiiboAPI.shared.fetchAmiiboList { model in
            guard let model = model else {
                return
            }
            DispatchQueue.main.async {
                let amiiboForViewList = model.map { amiibo in
                    return AmiiboForView(
                        name: amiibo.name,
                        gameSeries: amiibo.gameSeries,
                        imageUrl: amiibo.image,
                        count: 0
                    )
                }
            self.amiiboList = amiiboForViewList
            self.tableView.reloadData()
            }

        }
    }
    
    //MARK: - Setup View
    
    func setupView() {
        view.addSubview(tableView)
        
        tableView.register(AmiiboCell.self, forCellReuseIdentifier: "cellId")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amiiboList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let amiibo = amiiboList[indexPath.row]
        
        guard let amiiboCell = cell as? AmiiboCell else {
            return cell
        }
        
        amiiboCell.nameLabel.text = amiibo.name
        amiiboCell.gameSeriesLabel.text = amiibo.gameSeries
        amiiboCell.owningCountLabel.text = String(amiibo.count)
        
        
        if let url = URL(string: amiibo.imageUrl) {
            amiiboCell.imageIV.loadImage(from: url)
        }
        return cell
    }
    

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complectionHandler) in
            
            if self.amiiboList[indexPath.row].name == "Luigi" { //не даст удалить ячейку с именем Луиджи
                complectionHandler(false)
            } else {
                self.amiiboList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                complectionHandler(true)
            }
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let countAction = UIContextualAction(style: .normal, title: "Count up") { (action, view, completionHandler) in
            
            let currentCount = self.amiiboList[indexPath.row].count
            self.amiiboList[indexPath.row].count = currentCount + 1
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? AmiiboCell {
                cell.owningCountLabel.text = String(self.amiiboList[indexPath.row].count)
            }
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [countAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let amiibo = self.amiiboList[indexPath.row]
        let amiiboDetailVC = AmiiboDetailVC()
        amiiboDetailVC.amiibo = amiibo
        self.present(amiiboDetailVC, animated: true)
    }
}

