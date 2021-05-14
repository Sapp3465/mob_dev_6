//
//  CustomFlowLayout.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {

    private var layoutAttributesCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        if layoutAttributesCache.isEmpty { prepare() }
        for (_, layoutAttributes) in layoutAttributesCache where rect.intersects(layoutAttributes.frame) {
            layoutAttributesArray.append(layoutAttributes)
        }
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesCache[indexPath]
    }

    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
        
    }
    private var contentHeight: CGFloat = 0
    
    private func addLayoutAttribure(for rect: CGRect, at indexPath: IndexPath) {
        let targetLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        targetLayoutAttributes.frame = rect
        layoutAttributesCache[indexPath] = targetLayoutAttributes
    }
    
    override func prepare() {
        guard let collectionView = self.collectionView else { return }
        layoutAttributesCache.removeAll()

        let ordinarSize = CGSize(width: (contentWidth - 3 * 1) / 4, height: (contentWidth - 3 * 1) / 4)
        let tripledSize = CGSize(width: contentWidth - ordinarSize.width - 1, height: contentWidth - ordinarSize.width - 1)
        
        var (xOffset, yOffset): (CGFloat, CGFloat) = (0, 0)

        for rowNumber in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: rowNumber, section: 0)
            let point = CGPoint(x: xOffset, y: yOffset)
            
            switch (rowNumber) % 8 {
            case 0:
                
                addLayoutAttribure(for: CGRect(origin: point, size: ordinarSize), at: indexPath)
                xOffset += ordinarSize.width + 1
                
                contentHeight = yOffset + ordinarSize.height
            case 1:
                addLayoutAttribure(for: CGRect(origin: point, size: tripledSize), at: indexPath)
                contentHeight = yOffset + tripledSize.height
                xOffset = 0
                yOffset += ordinarSize.height + 1
                
            case 2, 3:
                addLayoutAttribure(for: CGRect(origin: point, size: ordinarSize), at: indexPath)
                xOffset = 0
                yOffset += ordinarSize.height + 1
                
            case 4, 5, 6:
                addLayoutAttribure(for: CGRect(origin: point, size: ordinarSize), at: indexPath)
                xOffset += ordinarSize.width + 1
                contentHeight = yOffset + ordinarSize.width + 1
            case 7:
                addLayoutAttribure(for: CGRect(origin: point, size: ordinarSize), at: indexPath)
                xOffset = 0
                yOffset += ordinarSize.height + 1
                
            default:
                continue
            }
        }
    }

}
