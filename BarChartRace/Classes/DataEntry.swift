//
//  BarEntry.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 16/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import Foundation
import UIKit

public struct DataEntry {
    var color: UIColor
    
    /// Ranged from 0.0 to 1.0
    var height: Float
    
    /// To be shown on top of the bar
    var textValue: String
    
    /// To be shown on top of the bar
    var textValueFont: UIFont   =   UIFont.systemFont(ofSize: 14)

    /// To be shown at the bottom of the bar
    var title: String
    
    /// To be shown at the bottom of the bar
    var titleValueFont: UIFont  =   UIFont.systemFont(ofSize: 14)
    
    public init(color: UIColor, height: Float, textValue: String, textValueFont: UIFont = UIFont.systemFont(ofSize: 14), title: String, titleValueFont:UIFont = UIFont.systemFont(ofSize: 14)) {
        self.color = color
        self.height = height
        self.textValue = textValue
        self.textValueFont = textValueFont
        self.title = title
        self.titleValueFont = titleValueFont
    }
}
