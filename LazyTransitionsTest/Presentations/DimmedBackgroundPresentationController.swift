import UIKit

final class DimmmedBackgroundPresentationController: UIPresentationController {

    var desiredSize: CGSize?
    var showsDismissButton = false

    fileprivate let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.alpha = 0.6
        view.addSubview(visualEffectView)

        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        self.setup()
    }

    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.dimmingView)

        self.dimmingView.alpha = 0.0

        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerViewBounds = self.containerView?.bounds {
            self.dimmingView.frame = containerViewBounds
        }

        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero

        guard let containerBounds = containerView?.bounds else {
            return presentedViewFrame
        }

        let contentContainer = self.presentedViewController
        if let desiredSize = self.desiredSize {
            presentedViewFrame.size = desiredSize
            presentedViewFrame.origin.x = (contentContainer.view.frame.size.width - desiredSize.width) / 2
            presentedViewFrame.origin.y = contentContainer.view.frame.size.height - desiredSize.height
        } else {
            presentedViewFrame.size = self.size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)
        }
        presentedViewFrame.size = self.desiredSize ?? self.size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)

        return presentedViewFrame
    }
}

private extension DimmmedBackgroundPresentationController {

    func setup() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dimmingViewTapped))
        self.dimmingView.addGestureRecognizer(tapRecognizer)
    }

    dynamic func dimmingViewTapped() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}
