import UIKit

extension UIViewController {
    func presentTextFieldAlert() {
        let alertVC = SimulationAlert()
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    func presentEndingAlert() {
        let alertVC = SimulationAlert(alertTitle: "Конец", message: "Вся группа полностью заражена", buttonTitle: "Ок")
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
}
