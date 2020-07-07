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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var barChart: BasicBarChart!
    
    var dataSets: [DataSet] =   []
    var colorsDict: [String: UIColor] = [:]
    var currentColorIndex: Int = 0
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromJson()
        
        barChart.delegate = self
        barChart.setupBarChartRace(dataSets, animated: true)
        barChart.timeInterval = TimeInterval(0.5)
        barChart.titleColor = .black
        barChart.valueColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        barChart.play()
    }
        
    //MARK: Private Functions
    
    private func readFromJson() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json")  else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [[String: Any]] {

                for data in jsonResult {
                    let dateString = data["date"] as? String
                    let entries = data["entries"] as? [[String: Any]] ?? []

                    guard let date = dateString?.formattedDate("yyyy-MM-dd") else { continue }
                    
                    let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 1, green: 0.8548190725, blue: 0.9710524141, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)]
                    var entriesList: [DataEntry] = []
                    
                    let maxEntryValue = entries.sorted(by: { $0["value"] as! Float > $1["value"] as! Float}).first?["value"] as? Float ?? 0.0
                    for entry in entries {
                        let title = entry["title"] as? String ?? ""
                        let value = entry["value"] as? Float ?? 0.0
                        
                        let height: Float = maxEntryValue > 0 ? Float(value) / maxEntryValue : 0
                        
                        if colorsDict[title] == nil {
                            colorsDict[title] = colors[currentColorIndex % colors.count]
                            currentColorIndex += 1
                        }
                        let dataEntry = DataEntry(color: colorsDict[title]!, height: height, textValue: "\(value)", title: title)
                        entriesList.append(dataEntry)
                    }
                    dataSets.append(DataSet(date, dataEntries: entriesList))
                }
                
            }
        } catch {
            // handle error
            print("\(error.localizedDescription)")
        }
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
    }
}


extension String {
    
    func formattedDate(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
}
