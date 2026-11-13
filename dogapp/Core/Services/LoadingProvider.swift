//
//  LoadingProvider.swift
//
//

import Foundation

@MainActor
protocol LoadingProvider<Value>: AnyObject, Observable {
    associatedtype Value

    var state: LoadingState<[Value], Error> { get }
    
    func loadIfNeeded() async
}
