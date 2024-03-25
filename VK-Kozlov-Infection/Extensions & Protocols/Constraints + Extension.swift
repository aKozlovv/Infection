import UIKit

extension NSLayoutConstraint {
    
    static func setSafeAreaLayout(_ view: UIView, _ controller: UIViewController) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    static func setFullScreenView(_ view: UIView, superview: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}
