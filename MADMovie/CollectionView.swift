//
//  CollectionView.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

//MARK: DefaultIdentifierProtocol
protocol DefaultIdentifierProtocol: class {
    static var identifier: String { get }
}

extension DefaultIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell : DefaultIdentifierProtocol {}

extension UICollectionView {
    func registerWithClass<T: DefaultIdentifierProtocol>(_: T.Type) {
        let identifier = T.identifier

        self.register(T.self, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: DefaultIdentifierProtocol>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
