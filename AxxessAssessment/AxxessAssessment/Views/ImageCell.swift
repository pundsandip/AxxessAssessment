//
//  ImageCell.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 27/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    static let identifier = "imageCellId"
    
    var lblId: UILabel!
    var lblDate: UILabel!
    var imgView: UIImageView!
    var dataModel: DataModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.addViews()
    }
    
    // MARK: Custome methods
    private func addViews() {
        lblId = UILabel(frame: .zero)
        self.contentView.addSubview(lblId)
        lblDate = UILabel(frame: .zero)
        self.contentView.addSubview(lblDate)
        imgView = UIImageView(frame: .zero)
        imgView.image = UIImage(named: "placeholder")
        self.contentView.addSubview(imgView)
        layout()
    }
    
    private func layout() {
        let offset = 16
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(offset)
            $0.left.equalToSuperview().offset(offset)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().offset(-offset)
        }
        lblId.snp.makeConstraints {
            $0.top.equalToSuperview().offset(offset)
            $0.left.equalTo(imgView.snp.right).offset(offset)
            $0.right.equalToSuperview().offset(-offset)
            $0.height.equalTo(21)
        }
        lblDate.snp.makeConstraints {
            $0.top.equalTo(lblId.snp.bottom).offset(8)
            $0.left.equalTo(imgView.snp.right).offset(offset)
            $0.right.equalToSuperview().offset(-offset)
            $0.height.equalTo(24)
        }
    }
    
    func setData(_ model: DataModel) {
        self.dataModel = model
        lblId.text = model.id
        lblDate.text = model.date
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
