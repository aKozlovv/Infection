import UIKit

final class SimulationAlert: UIViewController {
    
    // MARK: - Public properties
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    
    // MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.90
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 7
        button.setTitle(buttonTitle ?? "Ok", for: .normal)
        button.addTarget(self, action: #selector(dismissError), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Init
    init(alertTitle: String? = "Неверный ввод",
         message: String? = "Для запуска нужно заполнить все поля",
         buttonTitle: String? = "Ок")
    {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        setupUI()
        layoutUI()
    }
    
    
    // MARK: - Private methods
    private func configureContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"
    }
    
    private func configureMessageLabel() {
        messageLabel.text = message ?? "Unable to complete simulation"
        messageLabel.numberOfLines = 4
    }
    
    @objc
    private func dismissError() {
        dismiss(animated: true)
    }
}


// MARK: - UI Configuration
private extension SimulationAlert {
    
    func setupUI() {
        view.addSubview(containerView)
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
        view.addSubview(messageLabel)
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
    }
    
    func layoutUI() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
}
