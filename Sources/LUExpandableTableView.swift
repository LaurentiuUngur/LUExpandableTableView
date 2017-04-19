//
//  LUExpandableTableView.swift
//  LUExpandableTableView
//
//  Created by Laurentiu Ungur on 19/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit

/// A subclass of `UITableView` with expandable and collapsible sections
open class LUExpandableTableView: UITableView {
    // MARK: - Properties
    
    /// The object that acts as the data source of the expandable table view
    public weak var expandableTableViewDataSource: LUExpandableTableViewDataSource?
    /// The object that acts as the delegate of the expandable table view
    public weak var expandableTableViewDelegate: LUExpandableTableViewDelegate?
    
    /// The `UITableViewRowAnimation` animation used for showing/hiding rows when expand/collapse occurs. Default value is `fade`
    public var animation: UITableViewRowAnimation = .fade
    
    /** The object that acts as the data source of the table view.
     
    - Precondition: `expandableTableViewDataSource` should be used in order to configure data source
    */
    open override var dataSource: UITableViewDataSource? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            
            guard newValue is LUExpandableTableView else {
                preconditionFailure("You must use expandableTableViewDataSource property instead of dataSource property in order to set \(newValue.self) as data source")
            }
        }
    }
    
    /** The object that acts as the delegate of the table view.
     
    - Precondition: `expandableTableViewDelegate` should be used in order to configure delegate
    */
    open override var delegate: UITableViewDelegate? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            
            guard newValue is LUExpandableTableView else {
                preconditionFailure("You must use expandableTableViewDelegate property instead of delegate property in order to set \(newValue.self) as delegate")
            }
        }
    }
    
    /// A set that contains the indexes of sections that are expanded
    public fileprivate(set) var expandedSections = Set<Int>()
    
    // MARK: - Init
    
    /** Initializes and returns a table view object having the given frame and style.
     
    - Parameters:
        - frame: A rectangle specifying the initial location and size of the table view in its superview’s coordinates. The frame of the table view changes as table cells are added and deleted.
        - style: A constant that specifies the style of the table view. See `UITableViewStyle` for descriptions of valid constants.
     
    - Returns: Returns an initialized `UITableView` object, or `nil` if the object could not be successfully initialized.
    */
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        commonInit()
    }
    
    /** Returns an object initialized from data in a given unarchiver.
     
    - Parameter coder: An unarchiver object.
    - Retunrs: `self`, initialized using the data in *decoder*.
    */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    /// Private common initializer
    private func commonInit() {
        delegate = self
        dataSource = self
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 60
        sectionHeaderHeight = UITableViewAutomaticDimension
        estimatedSectionHeaderHeight = 60
    }
    
    // MARK: - Public Functions
    
    /** A function that determines whether the section at given index is expanded.
     
    - Parameter index: An index number identifying a section of table view
    - Returns: `true` if the section at given index is expanded, otherwise `false`
    */
    public func isExpandedSection(at index: Int) -> Bool {
        return expandedSections.contains(index)
    }

    /** A function that expands sections at given indexes
 
    - Parameter indexes: Index numbers identifying sections of table view
 
    - Note: Indexes that are out of bounds are ignored
    */
    public func expandSections(at indexes: [Int]) {
        perform(expanding: true, forSectionsAt: indexes)
    }

    /** A function that collapses sections at given indexes

    - Parameter indexes: Index numbers identifying sections of table view

    - Note: Indexes that are out of bounds are ignored
    */
    public func collapseSections(at indexes: [Int]) {
        perform(expanding: false, forSectionsAt: indexes)
    }

    // MARK: - Private Functions

    private func perform(expanding: Bool, forSectionsAt indexes: [Int]) {
        let goodIndexes = indexes.filter { $0 >= 0 && $0 < numberOfSections }

        guard goodIndexes.count > 0 else {
            return
        }

        if expanding {
            expandedSections.formUnion(goodIndexes)
        } else {
            goodIndexes.forEach {
                expandedSections.remove($0)
            }
        }

        beginUpdates()
        reloadSections(IndexSet(goodIndexes), with: animation)
        endUpdates()
    }
}

// MARK: - UITableViewDelegate

extension LUExpandableTableView: UITableViewDelegate {
    /** Asks the delegate for a view object to display in the header of the specified section of the table view.
    
    - Parameters:
        - tableView: The table-view object asking for the view object.
        - section: An index number identifying a section of `tableView`.
    */
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = expandableTableViewDataSource?.expandableTableView(self, sectionHeaderOfSection: section) else {
            return nil
        }
        
        sectionHeader.delegate = self
        sectionHeader.section = section
        sectionHeader.isExpanded = expandedSections.contains(section)
        
        return sectionHeader
    }

    /** Tells the delegate that the specified row is now selected.
 
    - Parameters:
        - tableView: A table-view object informing the delegate about the new row selection.
        - indexPath: An index path locating the new selected row in `tableView`.
    */
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandableTableViewDelegate?.expandableTableView(self, didSelectRowAt: indexPath)
    }

    /** Asks the delegate for the height to use for a row in a specified location

    - Parameters:
        - tableView: The table-view object requesting this information.
        - indexPath: An index path that locates a row in `tableView`.
     
    - Returns: A nonnegative floating-point value that specifies the height (in points) that row should be.
    */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandableTableViewDelegate?.expandableTableView(self, heightForRowAt: indexPath) ?? UITableViewAutomaticDimension
    }

    /** Asks the delegate for the height to use for the header of a particular section.

    - Parameters:
        - tableView: The table-view object requesting this information.
        - section: An index number identifying a section of `tableView`.
     
    - Returns: A nonnegative floating-point value that specifies the height (in points) of the header for section.
    */
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return expandableTableViewDelegate?.expandableTableView(self, heightForHeaderInSection: section) ?? UITableViewAutomaticDimension
    }

    /** Tells the delegate the table view is about to draw a cell for a particular row.

    - Parameters:
        - tableView: The table-view object informing the delegate of this impending event.
        - cell: A table-view cell object that tableView is going to use when drawing the row.
        - indexPath: An index path locating the row in `tableView`.
    */
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        expandableTableViewDelegate?.expandableTableView(self, willDisplay: cell, forRowAt: indexPath)
    }

    /** Tells the delegate that a header view is about to be displayed for the specified section.

    - Parameters:
        - tableView: The table-view object informing the delegate of this event.
        - view: The header view that is about to be displayed
        - section: An index number identifying a section of `tableView`.
    */
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        expandableTableViewDelegate?.expandableTableView(self, willDisplaySectionHeader: view as! LUExpandableTableViewSectionHeader, forSection: section)
    }
}

// MARK: - UITableViewDataSource

extension LUExpandableTableView: UITableViewDataSource {
    /** Tells the data source to return the number of rows in a given section of a table view.

    - Parameters:
        - tableView: The table-view object requesting this information.
        - section: An index number identifying a section of `tableView`.

    - Returns: The number of rows in `section`.
    */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSections.contains(section) ? (expandableTableViewDataSource?.expandableTableView(self, numberOfRowsInSection: section) ?? 0) : 0
    }

    /** Asks the data source to return the number of sections in the table view.

    - Parameter tableView: An object representing the table view requesting this information.

    - Returns: The number of sections in `tableView`. The default value is `1`.
    */
    public func numberOfSections(in tableView: UITableView) -> Int {
        return expandableTableViewDataSource?.numberOfSections(in: self) ?? 0
    }

    /** Asks the data source for a cell to insert in a particular location of the table view.

    - Parameters:
        - tableView: A table-view object requesting the cell.
        - indexPath: An index path locating a row in `tableView`.

    - Returns: An object inheriting from `UITableViewCell` that the table view can use for the specified row. An assertion is raised if you return `nil`.
    */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return expandableTableViewDataSource?.expandableTableView(self, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}

// MARK: - LUExpandableTableViewSectionHeaderDelegate

extension LUExpandableTableView: LUExpandableTableViewSectionHeaderDelegate {
    /** Tells the delegate that the specified section header should expand or collapse

    - Parameters:
        - sectionHeader: A section header object informing the delegate of this event
        - section: An index number identifying the section from a expandable table view that `sectionHeader` is displayed at
    */
    public func expandableSectionHeader(_ sectionHeader: LUExpandableTableViewSectionHeader, shouldExpandOrCollapseAtSection section: Int) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        
        beginUpdates()
        reloadSections(IndexSet(integer: section), with: animation)
        endUpdates()
        
        let sectionHeaderRect = rectForHeader(inSection: section)
        
        if !bounds.contains(sectionHeaderRect) {
            scrollRectToVisible(sectionHeaderRect, animated: true)
        }
    }

    /** Tells the delegate that the specified section header was selected

    - Parameters:
        - sectionHeader: A section header object informing the delegate of this event
        - section: An index number identifying the section from a expandable table view that `sectionHeader` was selected at
    */
    public func expandableSectionHeader(_ sectionHeader: LUExpandableTableViewSectionHeader, wasSelectedAtSection section: Int) {
        expandableTableViewDelegate?.expandableTableView(self, didSelectSectionHeader: sectionHeader, atSection: section)
    }
}
