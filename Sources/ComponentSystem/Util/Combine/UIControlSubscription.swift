//////
//////  UIControlSubscription.swift
//////  ComponentSystem
//////
//////  Created by Station3 on 9/12/25.
//////
////
////import Combine
////import UIKit
////
////@MainActor
////final class UIControlPublisher<Control: UIControl>: Publisher {
////    typealias Output = UIControl
////    typealias Failure = Never
////
////    private let control: UIControl
////    private let event: UIControl.Event
////    private let subject = PassthroughSubject<Output, Failure>()
////
////    deinit {
////        control.removeTarget(self, action: nil, for: event)
////    }
////
////    init(control: UIControl, event: UIControl.Event) {
////        self.control = control
////        self.event = event
////
////        control.addTarget(
////            self,
////            action: #selector(handler(sender:)),
////            for: event
////        )
////    }
////
////    func receive<S>(subscriber: S) where S : Subscriber,
////       S.Failure == UIControlPublisher.Failure,
////       S.Input == UIControlPublisher.Output {
////            subject.subscribe(subscriber)
////    }
////
////    @objc private func handler(sender: UIControl) {
////       subject.send(sender)
////    }
////}
////
////public struct UIControlPublsher<Control: UIControl>: Publisher {
////    /// Publisher 프로토콜의 associated type 필수 지정
////    public typealias Output = Control
////    public typealias Failure = Never
////
////    let control: Control
////    let controlEvent: UIControl.Event
////
////    init(control: Control, event: UIControl.Event) {
////        self.control = control
////        self.controlEvent = event
////    }
////
////    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Control == S.Input {
////        let subscription = UIControlSubscription(
////            subscriber: subscriber,
////            control: control,
////            event: controlEvent
////        )
////        subscriber.receive(subscription: subscription)
////    }
////}
////
////extension UIControl: CombineCompatible {}
////
////public extension CombineCompatible where Self: UIControl {
////    func publisher(for event: UIControl.Event) -> UIControlPublsher<UIControl> {
////        return UIControlPublsher(control: self, event: event)
////    }
////
////    func tapEvent() -> UIControlPublsher<UIControl> {
////        return publisher(for: .touchUpInside)
////    }
////}
//
//import Combine
//import UIKit
//
//// MARK: - UIControl + Combine Extension
//extension UIControl {
//    
//    /// UIControl 이벤트를 Combine Publisher로 변환
//    /// - Parameter event: 감지할 UIControl.Event
//    /// - Returns: AnyPublisher<UIControl, Never>
//    func publisher(for event: UIControl.Event) -> AnyPublisher<UIControl, Never> {
//        let subject = PassthroughSubject<UIControl, Never>()
//        
//        // Target-Action 래퍼 클래스 생성
//        let target = ControlTarget(control: self, event: event, subject: subject)
//        
//        // 강한 참조를 유지하기 위해 associated object로 저장
//        objc_setAssociatedObject(
//            self,
//            ControlTarget.associatedKey(for: event),
//            target,
//            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
//        )
//        
//        return subject.eraseToAnyPublisher()
//    }
//    
//    /// 탭 이벤트 전용 편의 메서드
//    var tapPublisher: AnyPublisher<UIControl, Never> {
//        return publisher(for: .touchUpInside)
//    }
//}
//
//// MARK: - Target-Action 래퍼 클래스
//@MainActor
//private class ControlTarget {
//    private weak var control: UIControl?
//    private let event: UIControl.Event
//    private let subject: PassthroughSubject<UIControl, Never>
//    
//    init(control: UIControl, event: UIControl.Event, subject: PassthroughSubject<UIControl, Never>) {
//        self.control = control
//        self.event = event
//        self.subject = subject
//        
//        control.addTarget(self, action: #selector(eventTriggered), for: event)
//    }
//    
//    @objc private func eventTriggered() {
//        guard let control = control else { return }
//        subject.send(control)
//    }
//    
//    deinit {
//        control?.removeTarget(self, action: #selector(eventTriggered), for: event)
//    }
//    
//    // Associated Object Key 생성
//    static func associatedKey(for event: UIControl.Event) -> String {
//        return "ControlTarget_\(event.rawValue)"
//    }
//}
//
//// MARK: - 편의 Extension들
//extension UIButton {
//    /// 버튼 탭 이벤트
//    var tapPublisher: AnyPublisher<UIButton, Never> {
//        publisher(for: .touchUpInside)
//            .compactMap { $0 as? UIButton }
//            .eraseToAnyPublisher()
//    }
//}
//
//extension UITextField {
//    /// 텍스트 변경 이벤트
//    var textChangePublisher: AnyPublisher<String?, Never> {
//        publisher(for: .editingChanged)
//            .compactMap { ($0 as? UITextField)?.text }
//            .eraseToAnyPublisher()
//    }
//    
//    /// 편집 완료 이벤트
//    var editingDidEndPublisher: AnyPublisher<String?, Never> {
//        publisher(for: .editingDidEnd)
//            .compactMap { ($0 as? UITextField)?.text }
//            .eraseToAnyPublisher()
//    }
//}
//
//extension UISwitch {
//    /// 스위치 상태 변경 이벤트
//    var isOnPublisher: AnyPublisher<Bool, Never> {
//        publisher(for: .valueChanged)
//            .compactMap { ($0 as? UISwitch)?.isOn }
//            .eraseToAnyPublisher()
//    }
//}
//
//// MARK: - 사용 예시
///*
//class ExampleViewController: UIViewController {
//    private let button = UIButton()
//    private let textField = UITextField()
//    private let toggle = UISwitch()
//    private var cancellables = Set<AnyCancellable>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupBindings()
//    }
//    
//    private func setupBindings() {
//        // 버튼 탭
//        button.tapPublisher
//            .sink { button in
//                print("Button tapped: \(button)")
//            }
//            .store(in: &cancellables)
//        
//        // 텍스트 변경
//        textField.textChangePublisher
//            .sink { text in
//                print("Text changed: \(text ?? "")")
//            }
//            .store(in: &cancellables)
//        
//        // 스위치 상태 변경
//        toggle.isOnPublisher
//            .sink { isOn in
//                print("Switch is now: \(isOn)")
//            }
//            .store(in: &cancellables)
//        
//        // 일반적인 이벤트 처리
//        button.publisher(for: .touchDown)
//            .sink { control in
//                print("Button touch down")
//            }
//            .store(in: &cancellables)
//    }
//}
//*/
