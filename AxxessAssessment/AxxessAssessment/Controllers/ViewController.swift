//
//  ViewController.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 25/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    var dataViewModel: DataViewModel?
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceManager.sharedInstance.getChallengeData { (response, error) in
            guard let model = response else { return }
            self.dataViewModel = DataViewModel(model)
            self.tableView.reloadData()
        }
        addViews()
    }
    
    private func addViews() {
        tableView = UITableView(frame: .zero)
        self.view.addSubview(tableView)
        layout()
    }

    private func layout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataViewModel?.sortedDataModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Image"
        } else {
            return "Text"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
         return dataViewModel?.imageDataModel.count ?? 0
        } else {
         return dataViewModel?.textDataModel.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.dataViewModel else { return UITableViewCell() }
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            let dataModel = viewModel.imageDataModel[indexPath.row]
            cell.setData(dataModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier, for: indexPath) as! TextCell
            let dataModel = viewModel.textDataModel[indexPath.row]
            cell.setData(dataModel)
            return cell
        }
    }
}

