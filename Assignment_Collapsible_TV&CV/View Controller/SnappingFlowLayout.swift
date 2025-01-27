//
//  SnappingFlowLayout.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 25/01/25.
//
import UIKit

class SnappingFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let collectionViewBounds = collectionView.bounds
        let halfWidth = collectionViewBounds.size.width / 2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        
        guard let attributesForVisibleCells = layoutAttributesForElements(in: collectionViewBounds) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        var closestAttribute: UICollectionViewLayoutAttributes?
        for attributes in attributesForVisibleCells {
            if closestAttribute == nil || abs(attributes.center.x - proposedContentOffsetCenterX) < abs(closestAttribute!.center.x - proposedContentOffsetCenterX) {
                closestAttribute = attributes
            }
        }
        
        guard let closest = closestAttribute else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        return CGPoint(x: closest.center.x - halfWidth, y: proposedContentOffset.y)
    }
}

