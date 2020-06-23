//
//  BasicBarChart.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 19/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

public class BasicBarChart: UIView {
    
    /// BarChart Race Delegate
    public var delegate: BarChartRaceDelegate?
    
    /// Time interval to update the data or to draw the next dataset
    public var timeInterval: TimeInterval   =   1.0
    
    /// Current state of the Player
    public var playerState: PlayerState     =   .unKnown {
        didSet {
            delegate?.playerStateUpdated(playerState)
        }
    }
    
    /// States of the player
    public enum PlayerState {
        case unKnown
        case playing
        case paused
        case stopped
    }

    /// contain all layers of the chart
    private let mainLayer: CALayer = CALayer()
    
    /// contain mainLayer to support scrolling
    private let scrollView: UIScrollView = UIScrollView()
    
    /// A flag to indicate whether or not to animate the bar chart when its data entries changed
    private var animated = false
    
    /// Responsible for compute all positions and frames of all elements represent on the bar chart
    private let presenter = BasicBarChartPresenter(barWidth: 40, space: 20)
    
    /// An array of bar entries. Each BasicBarEntry contain information about line segments, curved line segments, positions and frames of all elements on a bar.
    private var barEntries: [BasicBarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
            scrollView.isScrollEnabled = false
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
                        
            for (index, entry) in barEntries.enumerated() {
                showEntry(index: index, entry: entry, animated: animated, oldEntry: oldValue.safeValue(at: index))
            }
            
            showLeftAxis()
        }
    }
    
    /// Index of the current DataSet
    private var currentIndex: Int   =   0
    
    /// Timer to update the dataset
    private var timer: Timer?
    
    /// List of  dataset
    private var dataSets: [DataSet] = []
    
    private var maxLeftTextBarX: CGFloat = CGFloat(Float.greatestFiniteMagnitude)
    private var minBarY: CGFloat = CGFloat(Float.greatestFiniteMagnitude)
    private var maxBarY: CGFloat = CGFloat(Float.leastNormalMagnitude)
    private let leftAxisWidth: CGFloat = 1.0
    
    //MARK: Overridden Funnctions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataSet(presenter.dataSet, animated: false)
    }

    //MARK: Public Functions
    /// Setup the Barchar dataset values
    /// - Parameter dataSets: List of dataset to be used for bar chart race
    /// - Parameter animated: Animate Bar Chart Race. (true/false)
    public func setupBarChartRace(_ dataSets: [DataSet], animated: Bool) {
        self.animated = animated
        self.dataSets = dataSets
    }

    /// Plays the BarChart Race
    public func play() {
        playerState = .playing
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {[unowned self] (timer) in
            self.updateChart()
        }
        timer?.fire()
    }
    
    /// Pauses the BarChart Race
    public func pause() {
        playerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    /// Stops  BarChart Race
    public func stop() {
        playerState = .stopped
        timer?.invalidate()
        timer = nil
        currentIndex = 0
    }

    //MARK: Private Functions
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func updateDataSet(_ dataSet: DataSet?, animated: Bool) {
        guard let dataSet = dataSet else { return }
        presenter.dataSet = dataSet
        barEntries = presenter.computeBarEntries(viewWidth: self.frame.width, viewHeight: self.frame.height)
    }
    
    private func updateChart() {
        guard currentIndex <= dataSets.count - 1 else {
            stop()
            return
        }
        let dataSet = dataSets[currentIndex]
        presenter.dataSet = dataSet
        barEntries = presenter.computeBarEntries(viewWidth: self.frame.width, viewHeight: self.frame.height)
        delegate?.currentDataSet(dataSet)
        currentIndex += 1
    }
        
    private func showEntry(index: Int, entry: BasicBarEntry, animated: Bool, oldEntry: BasicBarEntry?) {
        
        let cgColor = entry.data.color.cgColor
        
        // Show the main bar
        mainLayer.addRectangleLayer(frame: entry.barFrame, color: cgColor, animated: animated, oldFrame: oldEntry?.barFrame)

        // Show an Int value above the bar
        mainLayer.addTextLayer(frame: entry.textValueFrame, color: cgColor, font: entry.data.textValueFont, text: entry.data.textValue, animated: animated, oldFrame: oldEntry?.textValueFrame)

//        // Show a title below the bar
        mainLayer.addTextLayer(frame: entry.bottomTitleFrame, color: cgColor, font: entry.data.titleValueFont, text: entry.data.title, animated: animated, oldFrame: oldEntry?.bottomTitleFrame)
       
        
        maxLeftTextBarX = entry.barFrame.origin.x
        
        if entry.barFrame.origin.y < minBarY {
            minBarY = entry.barFrame.origin.y
        }
        
        if entry.barFrame.maxY > maxBarY {
            maxBarY = entry.barFrame.maxY
        }
    }
    
    private func showHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let lines = presenter.computeHorizontalLines(viewHeight: self.frame.height)
        lines.forEach { (line) in
            mainLayer.addLineLayer(lineSegment: line.segment, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
        }
    }
    
    private func showLeftAxis() {
        let leftAxisX = maxLeftTextBarX - leftAxisWidth
        let lineSegment = LineSegment(startPoint: CGPoint(x: leftAxisX, y: minBarY), endPoint: CGPoint(x: leftAxisX, y: maxBarY))
        mainLayer.addLineLayer(lineSegment: lineSegment, color: UIColor.gray.cgColor, width: leftAxisWidth, isDashed: false, animated: false, oldSegment: nil)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
