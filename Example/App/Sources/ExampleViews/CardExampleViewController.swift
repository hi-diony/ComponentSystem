import UIKit

class CardExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Cards"
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Card 1: Basic Card
        let card1 = createCard(title: "Basic Card", 
                              subtitle: "A simple card with title and description", 
                              image: UIImage(systemName: "doc.text"),
                              showAction: false)
        
        // Card 2: Card with Image
        let card2 = createCard(title: "Image Card", 
                              subtitle: "Card with a header image and description", 
                              image: UIImage(systemName: "photo"),
                              showAction: true)
        
        // Card 3: Card with Action Buttons
        let card3 = createCard(title: "Action Card", 
                              subtitle: "Card with multiple action buttons", 
                              image: UIImage(systemName: "square.and.arrow.up"),
                              showAction: true)
        
        stackView.addArrangedSubview(card1)
        stackView.addArrangedSubview(card2)
        stackView.addArrangedSubview(card3)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func createCard(title: String, subtitle: String, image: UIImage?, showAction: Bool) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.text = subtitle
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(contentStack)
        
        var constraints = [
            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ]
        
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.tintColor = .systemBlue
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            cardView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
                imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
                imageView.widthAnchor.constraint(equalToConstant: 24),
                imageView.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        }
        
        if showAction {
            let button = UIButton(type: .system)
            button.setTitle("Action", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            cardView.addSubview(button)
            
            constraints.append(contentsOf: [
                button.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 12),
                button.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
                button.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
        return cardView
    }
}
