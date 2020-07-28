//
//  DataCell.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 26/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import UIKit
import SnapKit

class TextCell: UITableViewCell {
    static let identifier = "TextCellId"
    
    var lblId: UILabel!
    var lblDate: UILabel!
    var lblData: UILabel!
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
        lblData = UILabel(frame: .zero)
        lblData.numberOfLines = 0
        lblData.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(lblData)
        layout()
    }
    
    private func layout() {
        let offset = 16
        lblId.snp.makeConstraints {
            $0.top.equalToSuperview().offset(offset)
            $0.left.equalToSuperview().offset(offset)
            $0.right.equalToSuperview().offset(-offset)
            $0.bottom.equalTo(lblDate.snp.top).offset(-offset)
        }
        lblDate.snp.makeConstraints {
            $0.top.equalTo(lblId.snp.top).offset(offset)
            $0.left.equalToSuperview().offset(offset)
            $0.right.equalToSuperview().offset(-offset)
            $0.bottom.equalTo(lblData.snp.top).offset(-offset)
        }
        lblData.snp.makeConstraints {
            $0.top.equalTo(lblDate.snp.bottom).offset(offset)
            $0.left.equalTo(lblDate)
            $0.right.equalTo(lblDate)
            $0.bottom.equalToSuperview().offset(-offset)
        }
    }
    
    func setData(_ model: DataModel) {
        self.dataModel = model
        lblId.text = model.id
        lblDate.text = model.date
        lblData.text = model.data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
