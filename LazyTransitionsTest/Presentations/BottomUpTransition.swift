import LazyTransitions
import UIKit

final class BottomUpTransition: NSObject {

    // MARK: Added to convert to a LazyTransition
    public weak var delegate: TransitionAnimatorDelegate?
    public var orientation = TransitionOrientation.topToBottom
    public var allowedOrientations: [TransitionOrientation]? = [TransitionOrientation.topToBottom]

    @available(*, unavailable)
    public required init(orientation: TransitionOrientation) {
        self.orientation = orientation
        self.isReversed = true
        self.animationDuration = 0.3
    }

    // MARK: Begin original code

    let isReversed: Bool
    let animationDuration: TimeInterval

    init(isReversed: Bool, duration: TimeInterval) {
        self.isReversed = isReversed
        self.animationDuration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }

        let animatingViewController = self.isReversed ? fromViewController : toViewController

        let containerView = transitionContext.containerView

        let animationDuration = self.transitionDuration(using: transitionContext)

        let scaleOutTransform = CGAffineTransform(translationX: 0.0, y: animatingViewController.view.frame.height)
        let identityTransform = CGAffineTransform.identity
        animatingViewController.view.transform = self.isReversed ? identityTransform : scaleOutTransform

        containerView.addSubview(animatingViewController.view)

        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            animatingViewController.view.transform = self.isReversed ? scaleOutTransform : identityTransform
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if self.isReversed {
                animatingViewController.view.transform = identityTransform
            }
        }
    }
}

// MARK: Added to convert to a LazyTransition
extension BottomUpTransition: TransitionAnimatorType {

    func animationEnded(_ transitionCompleted: Bool) {
        delegate?.transitionDidFinish(transitionCompleted)
    }
}
