//
//  WebViewController.swift
//  LazyTransitions
//
//  Created by Joe Fabisevich on 5/10/17.
//  Copyright © 2017 Joe Fabisevich. All rights reserved.
//

import UIKit

final class WebViewController: UIViewController {
    
    let webView: UIWebView = {
        let webView = UIWebView()
        webView.scalesPageToFit = true
        
        return webView
    }()
    
    
    init(url: URL, title: String = "") {
        super.init(nibName: nil, bundle: nil)

        self.edgesForExtendedLayout = []
        
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
        
        self.title = title
        
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension WebViewController {
    
    func setup() {
        self.view.addSubview(self.webView)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
