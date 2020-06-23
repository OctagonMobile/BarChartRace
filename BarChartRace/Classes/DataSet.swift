//
//  DataSet.swift
//  BarChartRace
//
//  Created by Rameez on 23/06/2020.
//

public struct DataSet {
    public var date: Date
    public var dataEntries: [DataEntry]    =   []
    
    public init(_ date: Date, dataEntries: [DataEntry]) {
        self.date = date
        self.dataEntries = dataEntries
    }
}
