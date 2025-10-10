//
//  ToastManager.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//


import Foundation

class ToastManager: OperationQueue {
    static let shared = ToastManager()
    
    private override init() {
        super.init()
        
        maxConcurrentOperationCount = 1
    }
    
    func show(toast: Toast) {
        guard toast.isShowing == true else { return }
        
        if toast.queue == false {
            cancelCurrentOperation()
        }
        
        addOperation(ToastOperation(toast: toast))
    }
    
    func cancel(id: String) {
        let operation = operations.first { $0.name == id }
        operation?.cancel()
    }
    
    @MainActor func setup() {
        _ = KeyboardManager.shared
    }
    
    private func cancelCurrentOperation() {
        let executingOperations = operations.filter { $0.isExecuting }
        executingOperations.forEach { $0.cancel() }
    }
}
