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
    var space: CGFloat
    
    /// space at the left of the bar to show the title
    private let leftSpace: CGFloat = 55.0
    
    /// space at the top of each bar to show the value
    private let topSpace: CGFloat = 40.0
    
    var dataEntries: [DataEntry] = []
    var previousDataSet: DataSet?
    var dataSet: DataSet? {
        didSet {
            previousDataSet = oldValue
            dataEntries = dataSet?.dataEntries ?? []
        }
    }

    let minBarHeight: CGFloat = 20
    let maxBarTitleWidthPercent: CGFloat = 22
    let maxBarValueWidthPercent: CGFloat = 22
    
    init(barWidth: CGFloat = 40, space: CGFloat = 20) {
        self.barWidth = barWidth
        self.space = space
    }

    
    func computeBarEntries(viewWidth: CGFloat, viewHeight: CGFloat) -> ([BasicBarEntry], [BasicBarEntry]) {
        space = 0.0
        let availableHeight = viewHeight - 2 * space
        var result: [BasicBarEntry] = []
        
        let sortedDataEntries = dataEntries.sorted(by: { $0.height >= $1.height})
        let computedBarHeight =  (availableHeight * 2) / CGFloat((3 * dataEntries.count) - 1) //Height * 2 / (3Count - 1)
        
        let maxTitleWidth = viewWidth * maxBarTitleWidthPercent / 100
        var computedTitleWidth = computeTitleWidth(forHeight: computedBarHeight)
        if computedTitleWidth > maxTitleWidth {
            computedTitleWidth = maxTitleWidth
        }
        
        let maxValueWidth = viewWidth * maxBarValueWidthPercent / 100
        var computedValueWidth = computeBarValueWidth(forHeight: computedBarHeight)
        if computedValueWidth > maxValueWidth {
            computedValueWidth = maxValueWidth
        }
        
        let titlePadding: CGFloat = 10 /*Left and Right Title Padding*/
        let valuePadding: CGFloat = 16  /*Left and Right Value Padding*/
        let totalBarWidth = (viewWidth - computedTitleWidth - titlePadding - valuePadding - computedValueWidth)
       
        for (index, entry) in dataEntries.enumerated() {
            let entryHeight = CGFloat(entry.height) * totalBarWidth
            let indexInSortedDataEntries: Int = sortedDataEntries.firstIndex(where: { $0.title == entry.title}) ?? index
            
            let xPosition: CGFloat = computedTitleWidth + titlePadding /*Left and right padding for title*/
            let yPosition = space + CGFloat(indexInSortedDataEntries) * (computedBarHeight + computedBarHeight/2.0)
            
            let origin = CGPoint(x: xPosition, y: yPosition)
            
            let barEntry = BasicBarEntry(origin: origin, barWidth: entryHeight, barHeight: computedBarHeight, space:  computedBarHeight/2.0, data: entry, titleWidth: computedTitleWidth, valueWidth: computedValueWidth)
            
            result.append(barEntry)
            if space == 10.0 {
                space = 0.0
            }
        }
        let barEntries = result
        
        if let previousDataSet = previousDataSet, let dataSet = dataSet {
            let deletedEntries = previousDataSet.minus(dataSet)
            for i in 0 ..< deletedEntries.count {
                let entry = deletedEntries[i]
                let entryHeight = CGFloat(entry.height) * totalBarWidth
                let xPosition: CGFloat = computedTitleWidth + titlePadding /*Left and right padding for title*/
                let yPosition = -computedBarHeight
                let origin = CGPoint(x: xPosition, y: yPosition)
                let barEntry = BasicBarEntry(origin: origin, barWidth: entryHeight, barHeight: computedBarHeight, space:  computedBarHeight/2.0, data: entry, titleWidth: computedTitleWidth, valueWidth: computedValueWidth)
                if let index = previousDataSet.dataEntries.firstIndex(of: entry) {
                    result.insert(barEntry, at: index)
                }
            }
        }
        
        return (result, barEntries)
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
    
    func computeBarValueWidth(forHeight height: CGFloat) -> CGFloat {
        var maxWidth: CGFloat = 0.0
        
        for entry in dataEntries {
            let width = entry.textValue.width(withConstrainedHeight: height, font: entry.textValueFont)
            if width > maxWidth {
                maxWidth = width
            }
        }
        return maxWidth
    }
}
