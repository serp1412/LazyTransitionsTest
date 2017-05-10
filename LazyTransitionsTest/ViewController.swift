//
//  ViewController.swift
//  LazyTransitions
//
//  Created by Joe Fabisevich on 5/10/17.
//  Copyright © 2017 Joe Fabisevich. All rights reserved.
//

import UIKit
import LazyTransitions

class ViewController: UIViewController {
    
    fileprivate let transitioner = LazyTransitioner(animator: BottomUpTransition(isReversed: true, duration: 0.3))
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor.red
        button.setTitle("Tap me!", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.button)

        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        self.button.addTarget(self, action: #selector(openWebViewController), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func openWebViewController() {
        let url = URL(string: "https://www.google.com")!
        let webViewController = WebViewController(url: url, title: "Test")
        
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = transitioningDelegate
        
        transitioner.addTransition(forScrollView: webViewController.webView.scrollView)
        transitioner.addTransition(forView: webViewController.view)
        transitioner.triggerTransitionAction = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        navigationController.transitioningDelegate = transitioner
        
        self.present(navigationController, animated: true, completion: nil)
    }
}

