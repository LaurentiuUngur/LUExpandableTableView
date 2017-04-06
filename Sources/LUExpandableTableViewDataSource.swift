//
//  LUExpandableTableViewDataSource.swift
//  LUExpandableTableView
//
//  Created by Laurentiu Ungur on 19/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit

/** The `LUExpandableTableViewDataSource` protocol is adopted by an object that mediates the application’s data model for a `LUExpandableTableView` object.
The data source provides the table-view object with the information it needs to construct and modify a table view.
*/
public protocol LUExpandableTableViewDataSource: class {
    /** Asks the data source to return the number of sections in the expandable table view.
     
    - Parameter expandableTableView: An object representing the expandable table view requesting this information
     
    - Returns: The number of sections in `expandableTableView`
    */
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int
    
    /** Tells the data source to return the number of rows in a given section of an expandable table view
     
    - Parameters:
        - expandableTableView: An object representing the expandable table view requesting this information
        - section: An index number identifying a section in `expandableTableView`
     
    - Returns: The number of rows in `section`
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int
    
    /** Asks the data source for a cell to insert in a particular location of the expandable table view
     
    - Parameters:
        - expandableTableView: An expandable table view object requesting the cell
        - indexPath: An index path locating a row in `expandableTableView`
     
    - Returns: An object inheriting from `UITableViewCell` that the expandable table view can use for the specified row
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    /** Asks the data source for a `LUExpandableTableViewSectionHeader` object to be displayed as header of the specified section of the expandable table view
     
    - Parameters:
        - expandableTableView: An expandable table view object requesting the `LUExpandableTableViewSectionHeader` object
        - section: An index number identifying a section of `expandableTableView`
     
    - Returns: A `LUExpandableTableViewSectionHeader` object to be displayed as header of `section`
    */
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader
}
