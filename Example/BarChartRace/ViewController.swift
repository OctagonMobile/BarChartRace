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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var barChart: BasicBarChart!
    
    private let numSet = 80
    private let numEntry = 10

    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        let dataSets = generateRandomDataSets()
        barChart.setupBarChartRace(dataSets, animated: true)
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
    
    /// Stop Button Action
    /// - Parameter sender: Sender of the action.
    @IBAction func stopButtonAction(_ sender: Any) {
        self.barChart.stop()
    }
}

extension ViewController: BarChartRaceDelegate {
    
    func playerStateUpdated(_ state: BasicBarChart.PlayerState) {
        let playButtonTitle = (state == .playing) ? "Pause" : "Play"
        playButton.setTitle(playButtonTitle, for: .normal)
        stopButton.isEnabled = (state == .playing || state == .paused)
    }
    
    func currentDataSet(_ dataSet: DataSet) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        dateLabel.text = formatter.string(from: dataSet.date)
    }
}
