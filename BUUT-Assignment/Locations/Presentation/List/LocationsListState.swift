//
//  LocationsListState.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

enum LocationsListState: Equatable {
    case loading
    case loaded([Location])
    case empty
    case failed(String)
}
