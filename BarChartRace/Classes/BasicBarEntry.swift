//
//  BasicBarEntry.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 22/5/19.
//  Copyright © 2019 Nguyen Vu Nhat Minh. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

struct BasicBarEntry {
    let origin: CGPoint
    let barWidth: CGFloat
    let barHeight: CGFloat
    let space: CGFloat
    let data: DataEntry
    let titleWidth: CGFloat
    let valueWidth: CGFloat

    var bottomTitleFrame: CGRect {
        return CGRect(x: 5, y: origin.y , width: titleWidth, height: barHeight)
    }
    
    var textValueFrame: CGRect {
        return CGRect(x: origin.x + barWidth + 8.0, y: origin.y, width: valueWidth, height: barHeight)
    }
    
    var barFrame: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: barWidth, height: barHeight)
    }
}

struct HorizontalLine {
    let segment: LineSegment
    let isDashed: Bool
    let width: CGFloat
}
