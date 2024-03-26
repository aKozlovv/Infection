import UIKit

final class SimulationCell: UICollectionViewCell {
    
    static let reuseId = "simulation"
    
    // MARK: - UI Elements
    private lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "figure.stand")
        view.image = image
        view.tintColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    // MARK: - Init & Overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.tintColor = .label
    }
    
    
    // MARK: - Private methods
    private func setupUI() {
        contentView.addSubview(mainImageView)
        NSLayoutConstraint.setFullScreenView(mainImageView, superview: self.contentView)
    }
    
    
    // MARK: - Public methods
    func updateCellData(with person: Person) {
        if person.isInfected {
            mainImageView.tintColor = .red
        }
    }
}
