//
//  DetailViewController.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 28/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var data: String?
    var imageUrl: String?
    var indexPath: IndexPath!
    var txtView: UITextView!
    var imgView: UIImageView!
    
    init(_ data: String? = nil, imageUrl: String? = nil, indexPath: IndexPath? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        self.imageUrl = imageUrl
        self.indexPath = indexPath
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    private func addViews() {
        if self.data != nil {
            txtView = UITextView(frame: .zero)
            txtView.isEditable = false
            self.view.addSubview(txtView)
        }
        if self.imageUrl != nil {
            imgView = UIImageView(frame: .zero)
            imgView.image = UIImage(named: "placeholder")
            self.view.addSubview(imgView)
        }
        layout()
    }
    
    private func setData() {
        if let text = self.data {
            self.txtView.text = text
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            let attrString = NSAttributedString(string: text,
                                                attributes: [NSAttributedString.Key.paragraphStyle:style])
            txtView.attributedText = attrString
        }
        if let imageUrl = self.imageUrl {
            // get cache image if available or download
            ImageDownloadManager.shared.downloadImage(imageUrl, indexPath: self.indexPath) { [weak self ] (image, url, indexPathh, error) in
                if let indexPathNew = indexPathh, indexPathNew == self?.indexPath {
                    DispatchQueue.main.async {
                        self?.imgView.image = image
                    }
                }
            }
        }
    }
    
    // add constraint to views
    private func layout() {
        let horizontalOffset = 16
        let verticleOffset = 20
        if self.data != nil {
            txtView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(verticleOffset)
                $0.left.equalToSuperview().offset(horizontalOffset)
                $0.right.equalToSuperview().offset(-horizontalOffset)
                $0.bottom.equalToSuperview().offset(-verticleOffset)
            }
        }
        if self.imageUrl != nil {
            let width = UIScreen.main.bounds.width - 50
            let height = UIScreen.main.bounds.height - 250
            imgView.snp.makeConstraints {
                $0.height.equalTo(height)
                $0.width.equalTo(width)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
    }
}
