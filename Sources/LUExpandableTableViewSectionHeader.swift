//
//  LUExpandableTableViewSectionHeader.swift
//  LUExpandableTableView
//
//  Created by Laurentiu Ungur on 19/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit

/// An `UITableViewHeaderFooterView` subclass that has a `delegate`
open class LUExpandableTableViewSectionHeader: UITableViewHeaderFooterView {
    // MARK: - Properties
    
    /// The object that acts as the delegate of the section header
    open internal(set) weak var delegate: LUExpandableTableViewSectionHeaderDelegate?
    /// An index number identifying the section from a expandable table view that this section header is displayed at
    open var section = 0
    /// A boolean that indicates if it is expanded or not
    open var isExpanded = false
}

/// The delegate of a `LUExpandableTableViewSectionHeader` object must adopt the `LUExpandableTableViewSectionHeaderDelegate` protocol.
public protocol LUExpandableTableViewSectionHeaderDelegate: class {
    /** Tells the delegate that the specified section header should expand or collapse
     
    - Parameters:
        - sectionHeader: A section header object informing the delegate of this event
        - section: An index number identifying the section from a expandable table view that `sectionHeader` is displayed at
    */
    func expandableSectionHeader(_ sectionHeader: LUExpandableTableViewSectionHeader, shouldExpandOrCollapseAtSection section: Int)
    
    /** Tells the delegate that the specified section header was selected
     
    - Parameters:
        - sectionHeader: A section header object informing the delegate of this event
        - section: An index number identifying the section from a expandable table view that `sectionHeader` was selected at
    */
    func expandableSectionHeader(_ sectionHeader: LUExpandableTableViewSectionHeader, wasSelectedAtSection section: Int)
}
