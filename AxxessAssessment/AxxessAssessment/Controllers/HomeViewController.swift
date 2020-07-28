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
    var model: [DataModel] = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        addViews()
    }
    
    @objc func willEnterForeground() {
        checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkInternetConnection()
    }
    
    func checkInternetConnection() {
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            fetchDataAndUpdateUI()
        } else {
            print("Internet Not Connection Available!")
           readDataAndUpdateUI()
        }
    }
    
    private func fetchDataAndUpdateUI() {
        ServiceManager.sharedInstance.getChallengeData { (response, error) in
            // check for response
            guard let model = response else {
                self.readDataAndUpdateUI()
                return
            }
            self.model = model
            DatabaseManager.sharedInstance.storeDataInDatabse(dataModel: model)
            self.updateUI()
        }
    }
    
    private func readDataAndUpdateUI() {
        let list = DatabaseManager.sharedInstance.fetchDataFromDatabse()
        var dataModelarray: [DataModel] = []
        for item in list {
            for data in item.tasks {
                // somehow realm returning empty data
                let dataModel = DataModel(id: data.id, type: data.type, date: data.date, data: data.data)
                dataModelarray.append(dataModel)
            }
        }
        self.model = dataModelarray
        self.updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.dataViewModel = DataViewModel(self.model)
            self.tableView.reloadData()
        }
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataViewModel?.sortedDataModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Text"
        } else {
            return "Image"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            print("text count: \(dataViewModel?.textDataModel.count ?? 0)")
            return dataViewModel?.textDataModel.count ?? 0
        } else {
            print("image count: \(dataViewModel?.imageDataModel.count ?? 0)")
            return dataViewModel?.imageDataModel.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = self.dataViewModel else { return }
        // section == 1 is image type section
        if indexPath.section == 1 {
            if let urlString = viewModel.imageDataModel[indexPath.row].data {
                // downlaod image with high priority and cache it
                ImageDownloadManager.shared.downloadImage(urlString, indexPath: indexPath) { (image, url, indexPathh, error) in
                    if let indexPathNew = indexPathh, indexPathNew == indexPath {
                        DispatchQueue.main.async {
                            (cell as! ImageCell).imgView.image = image
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /* Reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
        guard let viewModel = self.dataViewModel else { return }
        if indexPath.section == 1 {
            if let urlString = viewModel.imageDataModel[indexPath.row].data {
                ImageDownloadManager.shared.slowDownImageDownloadTaskfor(urlString)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.dataViewModel else { return UITableViewCell() }
        // section == 0 is text type section, section == 1 is image type section
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier, for: indexPath) as! TextCell
            let dataModel = viewModel.textDataModel[indexPath.row]
            cell.setData(dataModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            let dataModel = viewModel.imageDataModel[indexPath.row]
            cell.setData(dataModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = self.dataViewModel else { return }
        // section == 0 is text type section, section == 1 is image type section
        if indexPath.section == 0 {
            let text = viewModel.textDataModel[indexPath.row].data
            let vc = DetailViewController(text)
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            let imageUrl = viewModel.imageDataModel[indexPath.row].data
            let vc = DetailViewController(imageUrl: imageUrl, indexPath: indexPath)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

