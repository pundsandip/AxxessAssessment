//
//  ActionProtocol.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 26/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import Foundation

public protocol DelegateAction { }
public protocol ActionDelegate: class {
    func actionSender(didReceiveAction action: DelegateAction)
}
