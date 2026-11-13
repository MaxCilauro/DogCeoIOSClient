//
//  LoadingState.swift
//
//

nonisolated enum LoadingState<Value, StateError: Swift.Error> {
    case loading
    case loaded(Value)
    case failed(StateError)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        
        return false
    }
    
    var isLoaded: Bool {
        if case .loaded = self {
            return true
        }
        
        return false
    }
    
    var isFailed: Bool {
        if case .failed = self {
            return true
        }
        
        return false
    }
    
    var value: Value? {
        if case .loaded(let value) = self {
            return value
        }
        
        return nil
    }
}
