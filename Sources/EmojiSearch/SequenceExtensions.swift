import Foundation

enum SortingOrder {
    case ascending
    case descending
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, order: SortingOrder = .ascending) -> [Element] {
        switch order {
        case .ascending:
            return sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        case .descending:
            return sorted { $0[keyPath: keyPath] > $1[keyPath: keyPath] }
        }
    }
}
