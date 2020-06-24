//
//  ViewController.swift
//  BarChartRace
//
//  Created by OctagonMobile on 06/18/2020.
//  Copyright (c) 2020 OctagonMobile. All rights reserved.
//

import UIKit
import BarChartRace

class ViewController: UIViewController {
    
//    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var barChart: BasicBarChart!
    
    private let numSet = 10
    private let numEntry = 10

    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        let dataSets = generateRandomDataSets()
        barChart.setupBarChartRace(dataSets, animated: true)
        barChart.titleColor = .black
        barChart.valueColor = .black
//        barChart.timeInterval = 1.0
//
//        slider.isContinuous = true
//        slider.value = 0
//        slider.minimumValue = 0.0
//        slider.maximumValue = Float(dataSets.count - 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        barChart.play()
    }
        
    //MARK: Private Functions
    /// Generates Random Data Sets.
    /// - Returns: List of Datset.
    private func generateRandomDataSets() -> [DataSet] {
        var result: [DataSet] = []
        for i in 0..<numSet {

            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))

            let entriesList: [DataEntry] = generateRandomDataEntries()
            let set = DataSet(date, dataEntries: entriesList)
            result.append(set)
        }

        return result
    }

    /// Generates Random Data Entry.
    /// - Returns: List of DataEntry.
    private func generateRandomDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: "Title \(i)"))
        }
            
        return result
    }
    
    private func updateDateOnUI(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        dateLabel.text = formatter.string(from: date)
    }
    
    //MARK: Button Actions
    /// Play/Pause Button's Action
    /// - Parameter sender: Sender of the action.
    @IBAction func playButtonAction(_ sender: Any) {
        if barChart.playerState == .playing {
            barChart.pause()
        } else {
            barChart.play()
        }
    }
}

extension ViewController: BarChartRaceDelegate {

    func playerStateUpdated(_ state: BasicBarChart.PlayerState) {
        let playButtonTitle = (state == .playing) ? "Pause" : "Play"

        playButton.setImage(UIImage(named: playButtonTitle), for: .normal)
    }

    func currentDataSet(_ dataSet: DataSet, index: Int) {

        updateDateOnUI(dataSet.date)

//        if barChart.playerState == .playing {
////            let calculatedValue = Float(index) / Float(numSet)
////            self.slider.setValue(calculatedValue, animated: true)
//
//            let animationTime = barChart.timeInterval //+ 0.5 // 0.5 is added to make it smoother
//            UIView.animate(withDuration: animationTime) {
//                let calculatedValue = Float(index) / Float(self.numSet-1)
//                self.slider.setValue(Float(calculatedValue), animated: true)
//            }
//        }
    }
}
