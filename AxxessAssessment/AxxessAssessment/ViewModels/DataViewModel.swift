//
//  ChallengeViewModel.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 26/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import Foundation
import Alamofire


class DataViewModel {
    var dataModel: [DataModel] = []
    var imageDataModel: [DataModel] = []
    var textDataModel: [DataModel] = []
    var sortedDataModel: [[DataModel]] = []
    
    enum DataType: String {
        case text
        case image
    }
    
    init(_ model: [DataModel]) {
        dataModel = model
        sortDataByType()
    }
    
    private func sortDataByType() {
       textDataModel =  dataModel.filter { $0.type == DataType.text.rawValue }
       imageDataModel =  dataModel.filter { $0.type == DataType.image.rawValue }
       sortedDataModel.append(textDataModel)
       sortedDataModel.append(imageDataModel)
    }
}
