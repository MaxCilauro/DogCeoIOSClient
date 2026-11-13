//
//  RemoteProvider.swift
//
//

import Foundation

@Observable
final class RemoteProvider<Value>: LoadingProvider {
    private(set) var state: LoadingState<[Value], Error> = .loading
    
    private let fetchValues: () async throws -> [Value]
    
    private var loadingTask: Task<Void, Never>?
    
    init(_ fetchValues: @escaping () async throws -> [Value]) {
        self.fetchValues = fetchValues
    }
    
    func loadIfNeeded() async {
        guard !self.state.isLoaded else {
            return
        }
        
        if let loadingTask {
            await loadingTask.value
            return
        }
        
        self.state = .loading
        
        await self.performLoadingTask()
    }
    
    private func performLoadingTask() async {
        self.loadingTask = Task { [weak self] in
            do {
                guard let values = try await self?.fetchValues() else {
                    return
                }
                
                try Task.checkCancellation()
                self?.state = .loaded(values)
            } catch {
                guard !Task.isCancelled else { return }
                
                self?.state = .failed(error)
            }
            
            self?.loadingTask = nil
        }
        
        await self.loadingTask?.value 
    }
}

