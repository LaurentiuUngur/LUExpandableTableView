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
    
    open override var dataSource: UITableViewDataSource? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            
            guard newValue is LUExpandableTableView else {
                preconditionFailure("\(newValue.self) shouldn't be set as data source. You must use expandableTableViewDataSource property instead of dataSource")
            }
        }
    }
    
    open override var delegate: UITableViewDelegate? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            
            guard newValue is LUExpandableTableView else {
                preconditionFailure("\(newValue.self) shouldn't be set as delegate. You must use expandableTableViewDelegate property instead of delegate")
            }
        }
    }
    
    /// A set that contains the sections that are expanded
    fileprivate var expandedSections = Set<Int>()
    
    // MARK: - Init
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
        dataSource = self
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 60
        sectionHeaderHeight = UITableViewAutomaticDimension
        estimatedSectionHeaderHeight = 60
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
