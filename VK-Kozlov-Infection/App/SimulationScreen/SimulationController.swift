import UIKit

final class SimulationController: UIViewController {
    
    // MARK: - Simulation parameters
    let groupSize: Int
    let infectionRate: Int
    let infectionPeriod: Int
    
    
    // MARK: - Private Properties
    /// Здесь хранятся индексы здоровых и больных людей, по которым в результате обновляются ячейки коллекции.
    private var timer: Timer?
    private var persons = [Person]()
    private lazy var indexesForUpdate = [Int]()
    private lazy var infectedPersonsIndex = [Int]()
    
    private lazy var queue = DispatchQueue.global(qos: .utility)
    private lazy var simulationView = SimulationView(controller: self)
    
    
    // MARK: - Init
    init(groupSize: Int, infectionRate: Int, infectionPeriod: Int) {
        self.groupSize = groupSize
        self.infectionRate = infectionRate
        self.infectionPeriod = infectionPeriod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        generatePersons()
        setupUI()
        startSimulation()
    }

        
    // MARK: - Initial methods
    private func setupUI() {
        view.addSubview(simulationView)
        simulationView.updateHealthyCounter(with: persons.count)
        NSLayoutConstraint.setSafeAreaLayout(simulationView, self)
    }
    
    private func generatePersons() {
        persons = [Person](repeating: Person(), count: groupSize)
    }
    
    private func personTapped(at index: Int) {
        guard persons[index].tryToInfect() else { return }
        
        infectedPersonsIndex.append(index)
        simulationView.updateInfectedCells(at: [index])
    }
    
    
    // MARK: - Simualtion methods
    /**
     Основной метод, который и производит симуляцию, а также отвечает за работу с потоками. В глобальной очереди метод "пробегается" по индексам зараженных людей и для каждого из них вызывает метод для заражения его соседей. Как только количество инфецированных индексов становится равно количеству элементов в изначальном массиве  - метод останавливает симуляцию.
     */
    @objc
    private func performSimulation() {
        
        guard infectedPersonsIndex.count != groupSize else {
            stopSimulation()
            return }
                
        queue.sync { [weak self] in
            guard let self = self else { 
                self?.stopSimulation()
                return }
                        
            self.infectedPersonsIndex.forEach( { self.infectNeighbors(near: $0) } )
            
            DispatchQueue.main.async {
                self.simulationView.updateInfectedCells(at: self.indexesForUpdate)
                self.simulationView.updateHealthyCounter(with: self.persons.count - self.infectedPersonsIndex.count)
                self.simulationView.updateInfectedCounter(with: self.infectedPersonsIndex.count)
            }
        }
    }
    
    /**
     Метод для заражения соседей по индексу
     */
    private func infectNeighbors(near index: Int) {
        let neighborsIndexes = getNeighbors(of: index)
        
        for index in neighborsIndexes {
            
            if persons[index].tryToInfect() {
                infectedPersonsIndex.append(index)
                indexesForUpdate.append(index)
            }
        }
    }
    
    /**
     функция вычисляет строку и столбец соответствующего индекса в двумерном массиве. Далее заполняется массив  соседних элементов (neighbor). Это происходит путем проверки каждой координаты в массиве координат на то, чтобы она попадала в границы массива. Если координата удовлетворяет этому условию и соответствует соседнему элементу в массиве, то  индекс элемента добавляется в массив neighbors. Перед возвратом массива neighbor метод также проверяет массив на соответствие infectionRate.
     */
    private func getNeighbors(of index: Int) -> [Int] {
        let coordinates = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        let columns = 5
        let row = index / columns
        let column = index % columns
        var neighbors = [Int]()
        
        for coordinate in coordinates {
            let newRow = row + coordinate.0
            let newColumn = column + coordinate.1
            
            if newRow >= 0 && newRow < groupSize / columns && newColumn >= 0 && newColumn < columns {
                let neighborIndex = newRow * columns + newColumn
                
                if (row == newRow && abs(column - newColumn) == 1) || (column == newColumn && abs(row - newRow) == 1) {
                    neighbors.append(neighborIndex)
                }
            }
        }
        
        guard neighbors.count <= infectionRate else {
            neighbors.removeLast(neighbors.count - infectionRate)
            return neighbors }
        
        return neighbors
    }
    
    /**
     Методы, которые управляют таймером и запускают/останавливают процесс симуляции. Таймер по заданному интервалу (infectionPeriod) вызывает основной метод симуляции - performSimulation
     */
    private func startSimulation() {
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(infectionPeriod),
            target: self,
            selector: #selector(performSimulation),
            userInfo: nil,
            repeats: true)
    }
    
    private func stopSimulation() {
        timer?.invalidate()
        timer = nil
        presentEndingAlert()
    }
}


// MARK: - UICollectionViewDelegate

extension SimulationController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !persons[indexPath.item].checkIsInfected() else { return }
        
        personTapped(at: indexPath.item)
    }
}


// MARK: - UICollectionViewDataSource

extension SimulationController: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimulationCell.reuseId, for: indexPath) as? SimulationCell else { return SimulationCell() }
        
        cell.updateCellData(with: persons[indexPath.item])
        
        return cell
    }
}

