//
//  BasicBarChartPresenter.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 22/5/19.
//  Copyright © 2019 Nguyen Vu Nhat Minh. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

class BasicBarChartPresenter {
    /// the width of each bar
    let barWidth: CGFloat
    
    /// the space between bars
    let space: CGFloat
    
    /// space at the left of the bar to show the title
    private let leftSpace: CGFloat = 55.0
    
    /// space at the top of each bar to show the value
    private let topSpace: CGFloat = 40.0
    
    var dataEntries: [DataEntry] = []
    
    let minBarHeight: CGFloat = 20
    
    init(barWidth: CGFloat = 40, space: CGFloat = 20) {
        self.barWidth = barWidth
        self.space = space
    }
    
    func computeContentWidth() -> CGFloat {
        return (barWidth + space) * CGFloat(dataEntries.count) + space
    }
    
    func computeBarEntries(viewWidth: CGFloat, viewHeight: CGFloat) -> [BasicBarEntry] {
        var result: [BasicBarEntry] = []
        
        let sortedDataEntries = dataEntries.sorted(by: { $0.height > $1.height})
        let computedBarHeight =  viewHeight * 2 / CGFloat((3 * dataEntries.count) + 1) //Height * 2 / (3Count + 1)
        var computedTitleWidth = computeTitleWidth(forHeight: computedBarHeight)
               if computedTitleWidth > viewWidth/10.0 {
                   computedTitleWidth = viewWidth/10.0
               }
        for (index, entry) in dataEntries.enumerated() {
            let titlePadding: CGFloat = 10 /*Left and Right Title Padding*/
            let entryHeight = CGFloat(entry.height) * (viewWidth - computedTitleWidth - titlePadding - topSpace)
            let indexInSortedDataEntries: Int = sortedDataEntries.firstIndex(where: { $0.title == entry.title}) ?? index
            
            let xPosition: CGFloat = computedTitleWidth + titlePadding /*Left and right padding for title*/
            let yPosition = space + CGFloat(indexInSortedDataEntries) * (computedBarHeight + computedBarHeight/2.0)

            let origin = CGPoint(x: xPosition, y: yPosition)
            
            let barEntry = BasicBarEntry(origin: origin, barWidth: entryHeight, barHeight: computedBarHeight, space:  computedBarHeight/2.0, data: entry, titleWidth: computedTitleWidth)
            
            result.append(barEntry)
        }
        
        return result
    }
    
    func computeTitleWidth(forHeight height: CGFloat) -> CGFloat {
        var maxWidth: CGFloat = 0.0
       
        for entry in dataEntries {
            let width = entry.title.width(withConstrainedHeight: height, font: entry.titleValueFont)
            if width > maxWidth {
                maxWidth = width
            }
        }
        return maxWidth
    }
    
    func computeHorizontalLines(viewHeight: CGFloat) -> [HorizontalLine] {
        var result: [HorizontalLine] = []
        
        let horizontalLineInfos = [
            (value: CGFloat(0.0), isDashed: false),
            (value: CGFloat(0.5), isDashed: true),
            (value: CGFloat(1.0), isDashed: false)
        ]
        
        for lineInfo in horizontalLineInfos {
            let yPosition = viewHeight - leftSpace -  lineInfo.value * (viewHeight - leftSpace - topSpace)
            
            let length = self.computeContentWidth()
            let lineSegment = LineSegment(
                startPoint: CGPoint(x: 0, y: yPosition),
                endPoint: CGPoint(x: length, y: yPosition)
            )
            let line = HorizontalLine(
                segment: lineSegment,
                isDashed: lineInfo.isDashed,
                width: 0.5)
            result.append(line)
        }
        
        return result
    }
}
