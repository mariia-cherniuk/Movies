//
//  MovieImagesCollectionLayout.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MosaicLayout: UICollectionViewLayout {
    private var cachedAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private let numberOfColumns: Int
    private let lineSpacing: CGFloat

    private weak var layoutDelegate: LayoutAdapter?
    
    init(layoutDelegate: LayoutAdapter, numberOfColumns: Int, spacing: CGFloat) {
        self.layoutDelegate = layoutDelegate
        self.numberOfColumns = numberOfColumns
        self.lineSpacing = spacing
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        cachedAttributes.removeAll()

        self.calculateAttributes()
    }
    
    override var collectionViewContentSize: CGSize {
        guard let cv = self.collectionView else { return CGSize.zero }
        
        return CGSize(width: cv.bounds.size.width, height: contentHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = self.collectionView else { return false }
        
        return newBounds.width != cv.bounds.width
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let result = cachedAttributes.filter { (key: IndexPath, attributes: UICollectionViewLayoutAttributes) -> Bool in
            return rect.intersects(attributes.frame)
        }
        
        return Array(result.values)
    }
}

//MARK: Helpers
extension MosaicLayout {
    private func calculateAttributes() {
        guard let cv = self.collectionView else { return }

        var yOrigins = self.startYOrigins()
        let itemWidth = self.itemWidth()
        
        for section in 0 ..< cv.numberOfSections {
            for item in 0 ..< cv.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let column = self.column(by: yOrigins)
                let xOrigin = self.xOrigin(for: column)
                let yOrigin = yOrigins[column]
                let height = layoutDelegate?.heightForPhoto(indexPath: indexPath, width: itemWidth) ?? 0
                let itemRect = CGRect(x: xOrigin, y: yOrigin, width: itemWidth, height: height)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = itemRect
                cachedAttributes[indexPath] = attributes
                
                yOrigins[column] = yOrigins[column] + height + lineSpacing
                contentHeight = max(contentHeight, itemRect.maxY)
            }
        }
    }
    
    private func collectionViewWidth() -> CGFloat {
        guard let cv = self.collectionView else { return 0 }
        
        return cv.bounds.size.width
    }
    
    private func itemWidth() -> CGFloat {
        let collectionViewWidth = self.collectionViewWidth()
        
        return (collectionViewWidth - CGFloat(numberOfColumns + 1) * lineSpacing) / CGFloat(numberOfColumns)
    }
    
    //place item to the smallest column
    private func column(by yOrigins: [CGFloat]) -> Int {
        let minYOrigin = yOrigins.min()!
        
        return yOrigins.firstIndex(of: minYOrigin)!
    }
    
    private func xOrigin(for column: Int) -> CGFloat {
        let itemWidth = self.itemWidth()
        
        return CGFloat(column) * itemWidth + CGFloat(column + 1) * lineSpacing
    }
    
    private func startYOrigins() -> [CGFloat] {
        return [CGFloat](repeating: lineSpacing, count: numberOfColumns)
    }
}
