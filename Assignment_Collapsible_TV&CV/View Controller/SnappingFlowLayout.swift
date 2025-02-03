//
//  SnappingFlowLayout.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 25/01/25.
//
import UIKit
//to determine where the collection view should stop after a user scrolls.
class SnappingFlowLayout: UICollectionViewFlowLayout { //organize its items in a grid-like structure and scrolling handle
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let collectionViewBounds = collectionView.bounds //If you zoom in or out the content inside the view, the bounds will change, but the frame will stay the same (position and size in the parent view).
        let halfWidth = collectionViewBounds.size.width / 2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        
        guard let attributesForVisibleCells = layoutAttributesForElements(in: collectionViewBounds) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)  //determine the point to which the collection view will scroll
        } //
        //It calculates the center of the visible area of the collection view
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

