import UIKit

class LoaderExampleViewController: UIViewController {
    
    private var loadingState: LoadingState = .idle
    private var loadingTimer: Timer?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Loaders"
        
        setupScrollView()
        setupLoaders()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadingTimer?.invalidate()
    }
    
    // MARK: - Setup
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func setupLoaders() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Activity Indicator
        let activityIndicatorSection = createSection(title: "Activity Indicators")
        let activityIndicatorStack = UIStackView()
        activityIndicatorStack.axis = .vertical
        activityIndicatorStack.spacing = 20
        
        // Small style
        let smallActivityIndicator = UIActivityIndicatorView(style: .medium)
        smallActivityIndicator.startAnimating()
        activityIndicatorStack.addArrangedSubview(createLoaderView(loader: smallActivityIndicator, title: "Small"))
        
        // Medium style
        let mediumActivityIndicator = UIActivityIndicatorView(style: .medium)
        mediumActivityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        mediumActivityIndicator.startAnimating()
        activityIndicatorStack.addArrangedSubview(createLoaderView(loader: mediumActivityIndicator, title: "Medium"))
        
        // Large style
        let largeActivityIndicator = UIActivityIndicatorView(style: .large)
        largeActivityIndicator.startAnimating()
        activityIndicatorStack.addArrangedSubview(createLoaderView(loader: largeActivityIndicator, title: "Large"))
        
        // Custom color
        let coloredActivityIndicator = UIActivityIndicatorView(style: .large)
        coloredActivityIndicator.color = .systemPurple
        coloredActivityIndicator.startAnimating()
        activityIndicatorStack.addArrangedSubview(createLoaderView(loader: coloredActivityIndicator, title: "Custom Color"))
        
        activityIndicatorSection.addArrangedSubview(activityIndicatorStack)
        stackView.addArrangedSubview(activityIndicatorSection)
        
        // Progress View
        let progressSection = createSection(title: "Progress Indicators")
        let progressStack = UIStackView()
        progressStack.axis = .vertical
        progressStack.spacing = 20
        
        // Default progress
        let defaultProgressView = UIProgressView(progressViewStyle: .default)
        defaultProgressView.progress = 0.3
        progressStack.addArrangedSubview(createLoaderView(loader: defaultProgressView, title: "Default"))
        
        // Bar progress
        let barProgressView = UIProgressView(progressViewStyle: .bar)
        barProgressView.progress = 0.5
        barProgressView.trackTintColor = .systemGray5
        barProgressView.progressTintColor = .systemBlue
        progressStack.addArrangedSubview(createLoaderView(loader: barProgressView, title: "Bar Style"))
        
        // Custom progress
        let customProgressView = UIProgressView(progressViewStyle: .default)
        customProgressView.progress = 0.7
        customProgressView.trackTintColor = .systemGray6
        customProgressView.progressTintColor = .systemPink
        customProgressView.layer.cornerRadius = 4
        customProgressView.clipsToBounds = true
        progressStack.addArrangedSubview(createLoaderView(loader: customProgressView, title: "Custom Style"))
        
        progressSection.addArrangedSubview(progressStack)
        stackView.addArrangedSubview(progressSection)
        
        // Custom Loaders
        let customSection = createSection(title: "Custom Loaders")
        let customStack = UIStackView()
        customStack.axis = .vertical
        customStack.spacing = 20
        
        // Pulsing dots
        let pulsingDotsView = PulsingDotsView()
        pulsingDotsView.translatesAutoresizingMaskIntoConstraints = false
        pulsingDotsView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        customStack.addArrangedSubview(createLoaderView(loader: pulsingDotsView, title: "Pulsing Dots"))
        
        // Rotating arc
        let rotatingArcView = RotatingArcView()
        rotatingArcView.translatesAutoresizingMaskIntoConstraints = false
        rotatingArcView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        customStack.addArrangedSubview(createLoaderView(loader: rotatingArcView, title: "Rotating Arc"))
        
        customSection.addArrangedSubview(customStack)
        stackView.addArrangedSubview(customSection)
        
        // Full Screen Loader Button
        let fullScreenButton = UIButton(type: .system)
        fullScreenButton.setTitle("Show Full Screen Loader", for: .normal)
        fullScreenButton.setTitleColor(.white, for: .normal)
        fullScreenButton.backgroundColor = .systemBlue
        fullScreenButton.layer.cornerRadius = 8
        fullScreenButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        fullScreenButton.addTarget(self, action: #selector(toggleFullScreenLoader), for: .touchUpInside)
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonContainer = UIView()
        buttonContainer.addSubview(fullScreenButton)
        
        NSLayoutConstraint.activate([
            fullScreenButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 20),
            fullScreenButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            fullScreenButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: -10)
        ])
        
        stackView.addArrangedSubview(buttonContainer)
    }
    
    private func createSection(title: String) -> UIStackView {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 12
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        
        sectionStack.addArrangedSubview(titleLabel)
        
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true
        
        sectionStack.addArrangedSubview(separator)
        
        return sectionStack
    }
    
    private func createLoaderView(loader: UIView, title: String) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel
        
        container.addSubview(titleLabel)
        container.addSubview(loader)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            loader.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            loader.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    // MARK: - Actions
    
    @objc private func toggleFullScreenLoader() {
        switch loadingState {
        case .idle, .finished:
            startLoading()
        case .loading:
            finishLoading()
        }
    }
    
    private func startLoading() {
        loadingState = .loading
        
        // Create and show full screen loading view
        let loadingView = UIView()
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.alpha = 0
        loadingView.tag = 999
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        
        let stackView = UIStackView(arrangedSubviews: [activityIndicator, label])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        loadingView.addSubview(stackView)
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.3) {
            loadingView.alpha = 1
        }
        
        // Simulate loading completion after 3 seconds
        loadingTimer?.invalidate()
        loadingTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.finishLoading()
        }
    }
    
    private func finishLoading() {
        loadingState = .finished
        loadingTimer?.invalidate()
        
        if let loadingView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.3, animations: {
                loadingView.alpha = 0
            }) { _ in
                loadingView.removeFromSuperview()
                self.loadingState = .idle
            }
        }
    }
    
    // MARK: - Enums
    
    private enum LoadingState {
        case idle
        case loading
        case finished
    }
}

// MARK: - Custom Loader Views

private class PulsingDotsView: UIView {
    
    private let dotSize: CGFloat = 10.0
    private let dotSpacing: CGFloat = 8.0
    private let animationDuration: TimeInterval = 0.8
    private let delayBetweenDots: TimeInterval = 0.15
    private let dotColor: UIColor = .systemBlue
    
    private var dotLayers: [CAShapeLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDots()
    }
    
    private func setupDots() {
        let dotCount = 3
        let totalWidth = (CGFloat(dotCount) * dotSize) + (CGFloat(dotCount - 1) * dotSpacing)
        
        for i in 0..<dotCount {
            let dotLayer = CAShapeLayer()
            dotLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotSize, height: dotSize)).cgPath
            dotLayer.fillColor = dotColor.cgColor
            
            let xPosition = (CGFloat(i) * (dotSize + dotSpacing)) + ((bounds.width - totalWidth) / 2)
            let yPosition = (bounds.height - dotSize) / 2
            
            dotLayer.frame = CGRect(x: xPosition, y: yPosition, width: dotSize, height: dotSize)
            
            layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dotCount = dotLayers.count
        let totalWidth = (CGFloat(dotCount) * dotSize) + (CGFloat(dotCount - 1) * dotSpacing)
        
        for (i, dotLayer) in dotLayers.enumerated() {
            let xPosition = (CGFloat(i) * (dotSize + dotSpacing)) + ((bounds.width - totalWidth) / 2)
            let yPosition = (bounds.height - dotSize) / 2
            
            dotLayer.frame = CGRect(x: xPosition, y: yPosition, width: dotSize, height: dotSize)
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        startAnimating()
    }
    
    func startAnimating() {
        for (index, dotLayer) in dotLayers.enumerated() {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1.0
            animation.toValue = 0.3
            animation.duration = animationDuration
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.beginTime = CACurrentMediaTime() + (Double(index) * delayBetweenDots)
            
            dotLayer.add(animation, forKey: "pulse")
        }
    }
    
    func stopAnimating() {
        for dotLayer in dotLayers {
            dotLayer.removeAllAnimations()
        }
    }
}

private class RotatingArcView: UIView {
    
    private let arcLayer = CAShapeLayer()
    private let animationKey = "rotation"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupArc()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupArc()
    }
    
    private func setupArc() {
        arcLayer.strokeColor = UIColor.systemBlue.cgColor
        arcLayer.fillColor = nil
        arcLayer.lineWidth = 3.0
        arcLayer.lineCap = .round
        
        layer.addSublayer(arcLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) * 0.4
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + (CGFloat.pi * 1.5)
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        arcLayer.path = path.cgPath
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        startRotating()
    }
    
    func startRotating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1.5
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        
        layer.add(rotation, forKey: animationKey)
    }
    
    func stopRotating() {
        layer.removeAnimation(forKey: animationKey)
    }
}
