//
//  LUExpandableTableViewDelegate.swift
//  LUExpandableTableView
//
//  Created by Laurentiu Ungur on 19/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit

/// The delegate of a `LUExpandableTableView` object must adopt the `LUExpandableTableViewDelegate` protocol.
public protocol LUExpandableTableViewDelegate: class {
    /** Asks the delegate for the height to use for a row in a specified location
    
    - Parameters:
        - expandableTableView: The expandable table view object requesting this information
        - indexPath: An index path that locates a row in `expandableTableView`
     
    - Warning: Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
     
    - Returns: A nonnegative floating-point value that specifies the height (in points) that row should be
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    /** Asks the delegate for the height to use for the header of a particular section
     
    - Parameters:
        - expandableTableView: The expandable table view object requesting this information
        - section: An index number identifying a section of `expandableTableView`
     
    - Warning: Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions

    - Returns: A nonnegative floating-point value that specifies the height (in points) of the header for `section`
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat
    
    /** Tells the delegate that the specified row is now selected
     
    - Parameters:
        - expandableTableView: An expandable table view object informing the delegate about the new row selection
        - indexPath: An index path locating the new selected row in `expandableTableView`
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath)
    
    /** Tells the delegate that the specified section header is now selected
     
     - Parameters:
        - expandableTableView: An expandable table view object informing the delegate about the new section header selection
        - sectionHeader: The section header that is selected
        - section: An index number identifying a section of `expandableTableView`
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int)
    
    /** Tells the delegate the expandable table view is about to draw a cell for a particular row
     
    - Parameters:
        - expandableTableView: The expandable table view object informing the delegate of this event
        - cell: A table-view cell object that `expandableTableView` is going to use when drawing the row
        - indexPath: An index path locating the row in `expandableTableView`
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    /** Tells the delegate that a section header is about to be displayed for the specified section
     
    - Parameters:
        - expandableTableView: The expandable table view object informing the delegate of this event
        - sectionHeader: The section header that is about to be displayed
        - section: An index number identifying a section of `expandableTableView`
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplaySectionHeader sectionHeader: LUExpandableTableViewSectionHeader, forSection section: Int)
}

// MARK: - Optional Delegates

public extension LUExpandableTableViewDelegate {
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int) {
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplaySectionHeader sectionHeader: LUExpandableTableViewSectionHeader, forSection section: Int) {
    }
}
