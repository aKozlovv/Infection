import UIKit

final class SimulationView: UIView {
    
    // MARK: Delegate
    weak var controller: SimulationController?
    
    
    // MARK: - Private properties
    private var scale: CGFloat = 1
    
    
    // MARK: - UI Elements
    // MARK: - Header
    private lazy var healthyCounterContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var healthyCounter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var infectedCounterContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var infectedCounter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.text = "0" + "\n больные"
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    
    // MARK: - ScrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.backgroundColor = .systemGray6
        scrollView.layer.borderWidth = 1
        scrollView.layer.borderColor = UIColor.label.cgColor
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
        
        scrollView.bounces = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    
    // MARK: - UICollectionView
    private lazy var mainCollection: UICollectionView = {
        let view = UICollectionView(frame: CGRect(x: 0, y: 10,
                                                  width: UIScreen.main.bounds.width,
                                                  height: UIScreen.main.bounds.height * 2),
                                    collectionViewLayout: setupCollectionLayout())
        
        view.contentSize = CGSize(width: UIScreen.main.bounds.width * 3,
                                  height: UIScreen.main.bounds.height * 2)
        
        view.register(SimulationCell.self, forCellWithReuseIdentifier: SimulationCell.reuseId)
        
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = controller
        view.delegate = controller
        
        view.allowsMultipleSelection = true
        view.isScrollEnabled = false
        view.alwaysBounceVertical = true
        view.alwaysBounceHorizontal = true
        
        return view
    }()
    
    
    // MARK: - Init
    init(controller: SimulationController) {
        super.init(frame: .zero)
        self.controller = controller
        self.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        layoutUI()
        setupPinchGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    /// Распознаватель жестов для реализации зума
    private func setupPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        mainCollection.addGestureRecognizer(pinchGesture)
    }
    
    
    // MARK: - Public methods
    func updateInfectedCells(at indexes: [Int]) {
        let indexPaths = indexes.map( { IndexPath(item: $0, section: 0)})
        mainCollection.reconfigureItems(at: indexPaths)
    }
    
    func updateHealthyCounter(with value: Int) {
        healthyCounter.text = String(value) + "\n здоровые"
    }
    
    func updateInfectedCounter(with value: Int) {
        infectedCounter.text = String(value) + "\n больные"
    }
}


// MARK: - UIGestureRecognizerDelegate
/**
 Методы, необходимые для реализации зума представления симуляции.
 */
extension SimulationView: UIGestureRecognizerDelegate {
    
    @objc
    func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            scale *= gestureRecognizer.scale
            gestureRecognizer.scale = 1.0
            
            mainCollection.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


// MARK: - UI Configuration extension
private extension SimulationView {
    
    func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(mainCollection)
        
        addSubview(healthyCounterContainer)
        healthyCounterContainer.addSubview(healthyCounter)
        
        addSubview(infectedCounterContainer)
        infectedCounterContainer.addSubview(infectedCounter)
    }
    
    func layoutUI() {
        NSLayoutConstraint.activate([
            healthyCounterContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            healthyCounterContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            healthyCounterContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            healthyCounterContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            
            healthyCounter.centerXAnchor.constraint(equalTo: healthyCounterContainer.centerXAnchor),
            healthyCounter.centerYAnchor.constraint(equalTo: healthyCounterContainer.centerYAnchor),
            
            infectedCounterContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            infectedCounterContainer.leadingAnchor.constraint(equalTo: healthyCounterContainer.trailingAnchor, constant: 15),
            infectedCounterContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            infectedCounterContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            
            infectedCounter.centerXAnchor.constraint(equalTo: infectedCounterContainer.centerXAnchor),
            infectedCounter.centerYAnchor.constraint(equalTo: infectedCounterContainer.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: infectedCounter.bottomAnchor, constant: 35),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    
    // MARK: - CollectionView layout
    func setupCollectionLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        
        return layout
    }
}
