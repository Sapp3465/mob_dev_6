//
//  LoadingError.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import Foundation

enum LoadingError: LocalizedError {
    case loading
    
    var errorDescription: String? {
        return "Unable to load some content!"
    }
}
