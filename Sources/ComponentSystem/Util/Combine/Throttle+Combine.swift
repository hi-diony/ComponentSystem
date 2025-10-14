//
//  Throttle+Combine.swift
//  ComponentSystem
//
//  Created by 박지연 on 10/14/25.
//


import Combine
import Foundation

extension Publisher {
    public func throttle(for interval: RunLoop.SchedulerTimeType.Stride = .milliseconds(300),
                         latest: Bool = false) -> AnyPublisher<Output, Failure> {
        // refs: https://heckj.github.io/swiftui-notes/#reference-throttle 에 의하면 13.3버전부터 구현방식이 달라졌다함..
        if latest == true {
            throttle(for: interval, scheduler: RunLoop.main, latest: true)
                .eraseToAnyPublisher()
        }
        else {
            scan((nil as RunLoop.SchedulerTimeType?, nil as Output?)) { state, output in
                let now = RunLoop.main.now
                if let lastEmission = state.0,
                    now < lastEmission.advanced(by: interval) {
                    // throttle 간격 내이면 이벤트를 무시 (nil)
                    return (lastEmission, nil)
                }
                else {
                    // 간격이 지났으므로, 현재 시간으로 업데이트하고 이벤트 방출
                    return (now, output)
                }
            }
            .compactMap { $0.1 }
            .eraseToAnyPublisher()
        }
    }
}
