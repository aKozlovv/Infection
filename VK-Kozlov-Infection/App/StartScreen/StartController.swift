import UIKit

final class StartController: UIViewController {
    
    // MARK: - View layer
    private lazy var startView = StartView(controller: self)
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        createDismissKeyboardTap()
    }
    
    
    // MARK: - Private methods
    private func setupUI() {
        view.addSubview(startView)
        NSLayoutConstraint.setSafeAreaLayout(startView, self)
    }
    
    private func createDismissKeyboardTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Public methods
    func startSimulation(group: Int, infRate: Int, period: Int) {
        let vc = SimulationController(groupSize: group, infectionRate: infRate, infectionPeriod: period)
        navigationController?.pushViewController(vc, animated: true)
    }
}

