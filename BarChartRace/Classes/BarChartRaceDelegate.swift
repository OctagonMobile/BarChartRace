//
//  BarChartRaceDelegate.swift
//  BarChartRace
//
//  Created by Rameez on 23/06/2020.
//

import UIKit

public protocol BarChartRaceDelegate {
    /// Called when the players state gets updated
    /// - Parameter state: Current state of the player
    func playerStateUpdated(_ state: BasicBarChart.PlayerState)
    
    /// Called when the barchart's dataset updated
    /// - Parameter dataSet: Current dataset shown on the barchart
    func currentDataSet(_ dataSet: DataSet, index: Int)
}

