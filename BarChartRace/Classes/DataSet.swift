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


extension DataSet {
    public func minus(_ dataSet: DataSet) -> [DataEntry] {
        var deletedEntries : [DataEntry] = []
        deletedEntries = self.dataEntries.filter {
            return !dataSet.dataEntries.contains($0)
        }
        return deletedEntries
    }
}

protocol Reorderable {
    associatedtype OrderElement: Equatable
    var orderElement: OrderElement { get }
}

extension Array where Element: Reorderable {

    func reorder(by preferredOrder: [Element.OrderElement]) -> [Element] {
        sorted {
            guard let first = preferredOrder.firstIndex(of: $0.orderElement) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: $1.orderElement) else {
                return true
            }

            return first < second
        }
    }
}
