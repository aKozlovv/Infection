import UIKit

final class StartView: UIView {
    
    private enum Titles {
        static let groupSizeTitle = "Размер группы"
        static let infectionTitle = "Число заражений за контакт"
        static let periodTitle = "Период пересчета (секунды)"
        static let buttonTitle = "Начать симуляцию"
    }
    
    // MARK: Delegate
    weak var controller: StartController?
    
    
    // MARK: - UI Elements
    // MARK: - UIImageView
    private lazy var mainImageView: UIImageView = {
        let image = UIImage(named: "Virus")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - TextFields
    private lazy var groupSizeTextField: SimulationTextField = {
        let field = SimulationTextField(title: Titles.groupSizeTitle)
        return field
    }()
    
    private lazy var infectionFactorTextField: SimulationTextField = {
        let field = SimulationTextField(title: Titles.infectionTitle)
        return field
    }()
    
    private lazy var periodTextField: SimulationTextField = {
        let field = SimulationTextField(title: Titles.periodTitle)
        return field
    }()
    
    private lazy var textFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [groupSizeTextField, infectionFactorTextField, periodTextField])
        stack.axis = .vertical
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - Button
    private lazy var startSimulationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.setTitle(Titles.buttonTitle, for: .normal)
        return button
    }()
    
    
    // MARK: - Init
    init(controller: StartController) {
        super.init(frame: .zero)
        self.controller = controller
        self.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - TextField validation
    @objc
    private func startButtonTapped() {
        guard let group = Int.convertStringToInt(from: groupSizeTextField.text) else {
            controller?.presentTextFieldAlert()
            return
        }
        
        guard let factor = Int.convertStringToInt(from: infectionFactorTextField.text) else {
            controller?.presentTextFieldAlert()
            return
        }
        
        guard let period = Int.convertStringToInt(from: periodTextField.text) else {
            controller?.presentTextFieldAlert()
            return
        }
        
        controller?.startSimulation(group: group, infRate: factor, period: period)
    }
    
    
    // MARK: - UI Configuration
    private func setupUI() {
        addSubview(mainImageView)
        addSubview(textFieldStack)
        addSubview(startSimulationButton)
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            mainImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            mainImageView.widthAnchor.constraint(equalToConstant: 200),
            
            textFieldStack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor,constant: 25),
            textFieldStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textFieldStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            startSimulationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            startSimulationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            startSimulationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            startSimulationButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
