//
//  ViewController.swift
//  MVVM-TableView
//
//  Created by 光光 on 7/24/19.
//  Copyright © 2019 feilei. All rights reserved.
//

import UIKit
import SDWebImage
class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    lazy var viewmodel: ViewModel = {
        return ViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createui()
        createvm()
    }
    func createui() {
        self.view.backgroundColor = .black
        tableview.register(UINib(nibName: "ViewCell", bundle: nil), forCellReuseIdentifier: "viewcell")
    }
    func createvm() {
        
        viewmodel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableview.reloadData()
            }
        }
        viewmodel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewmodel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewmodel.initData()
    }
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: TableViewDelegate
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.numberCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "viewcell", for: indexPath) as? ViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        cell.config = viewmodel.dataViewModel(indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewmodel.promptMessage(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

