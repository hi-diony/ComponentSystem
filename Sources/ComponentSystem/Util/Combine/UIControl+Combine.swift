//
//  UIControlSubscription.swift
//  ComponentSystem
//
//  Created by 박지연 on 10/14/25.
//

import UIKit
import Combine

@MainActor
final fileprivate class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription
where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private unowned let control: Control
    private let event: UIControl.Event

    @MainActor
    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.event = event
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    nonisolated func request(_ demand: Subscribers.Demand) {}

    nonisolated func cancel() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.control.removeTarget(self, action: #selector(self.eventHandler), for: self.event)
            self.subscriber = nil
        }
    }

    @MainActor
    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

public struct UIControlPublisher<Control: UIControl>: @preconcurrency Publisher, @unchecked Sendable {
    public typealias Output = Control
    public typealias Failure = Never

    let control: Control
    let controlEvent: UIControl.Event

    init(control: Control, event: UIControl.Event) {
        self.control = control
        self.controlEvent = event
    }

    @MainActor
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Control == S.Input {
        let subscription = UIControlSubscription(
            subscriber: subscriber,
            control: control,
            event: controlEvent
        )
        subscriber.receive(subscription: subscription)
    }
}

extension UIControl: CombineCompatible {}

public extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, event: event)
    }

    func tap() -> UIControlPublisher<UIControl> {
        return publisher(for: .touchUpInside)
    }
}
