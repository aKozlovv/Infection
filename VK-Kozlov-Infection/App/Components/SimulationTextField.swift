import UIKit

final class SimulationTextField: UITextField {
    
    // MARK: - UI Elements
    private lazy var bottomView: UIView = {
        var bottomView = UIView()
        bottomView.backgroundColor = .label
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    
    
    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        
        self.font = .preferredFont(forTextStyle: .subheadline)
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = title
        self.keyboardType = .numberPad
        
        self.addSubview(bottomView)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    private func layout() {
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
