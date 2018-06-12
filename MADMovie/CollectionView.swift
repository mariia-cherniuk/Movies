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

//MARK: DefaultNibProtocol
protocol DefaultNibProtocol: class {
    static var nibName: String { get }
}

extension DefaultNibProtocol {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell : DefaultIdentifierProtocol, DefaultNibProtocol {}

extension UICollectionView {
    func registerWithClass<T: DefaultIdentifierProtocol & DefaultNibProtocol>(_: T.Type) {
        let identifier = T.identifier
        let nib = UINib(nibName: T.nibName, bundle: nil)

        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: DefaultIdentifierProtocol>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
