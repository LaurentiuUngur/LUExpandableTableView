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
    
    /// A set that contains the sections that are expanded
    fileprivate var expandedSections = Set<Int>()
    
    // MARK: - Init
    
    /** Initializes and returns a table view object having the given frame and style.
     
    - Parameters:
        - frame: A rectangle specifying the initial location and size of the table view in its superview’s coordinates. The frame of the table view changes as table cells are added and deleted.
        - style: A constant that specifies the style of the table view. See `UITableViewStyle` for descriptions of valid constants.
     
    - Returns: Returns an initialized `UITableView` object, or `nil` if the object could not be successfully initialized.
    */
    override init(frame: CGRect, style: UITableViewStyle) {
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
     
    - Parameter index: An index number identifying a section of tableView
    - Returns: `true` if the section at given index is expanded, otherwise `false`
    */
    public func isExpandedSection(at index: Int) -> Bool {
        return expandedSections.contains(index)
    }
}

// MARK: - UITableViewDelegate

extension LUExpandableTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = expandableTableViewDataSource?.expandableTableView(self, sectionHeaderOfSection: section) else {
            return nil
        }
        
        sectionHeader.delegate = self
        sectionHeader.section = section
        sectionHeader.isExpanded = expandedSections.contains(section)
        
        return sectionHeader
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandableTableViewDelegate?.expandableTableView(self, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandableTableViewDelegate?.expandableTableView(self, heightForRowAt: indexPath) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return expandableTableViewDelegate?.expandableTableView(self, heightForHeaderInSection: section) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        expandableTableViewDelegate?.expandableTableView(self, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        expandableTableViewDelegate?.expandableTableView(self, willDisplaySectionHeader: view as! LUExpandableTableViewSectionHeader, forSection: section)
    }
}

// MARK: - UITableViewDataSource

extension LUExpandableTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSections.contains(section) ? (expandableTableViewDataSource?.expandableTableView(self, numberOfRowsInSection: section) ?? 0) : 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return expandableTableViewDataSource?.numberOfSections(in: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return expandableTableViewDataSource?.expandableTableView(self, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}

// MARK: - LUExpandableTableViewSectionHeaderDelegate

extension LUExpandableTableView: LUExpandableTableViewSectionHeaderDelegate {
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
    
    public func expandableSectionHeader(_ sectionHeader: LUExpandableTableViewSectionHeader, wasSelectedAtSection section: Int) {
        expandableTableViewDelegate?.expandableTableView(self, didSelectSectionHeader: sectionHeader, atSection: section)
    }
}
