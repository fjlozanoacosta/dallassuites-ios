//
//  RatesViewController.swift
//  Dallas Suites
//
//  Created by Roberto Rumbaut on 2/14/17.
//  Copyright © 2017 ICO Group. All rights reserved.
//

import UIKit

class RatesViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup nav bar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
        // Load page
        activityIndicator.startAnimating()
        let request = URLRequest(url: URL(string: RatesURL)!)
        webView.scrollView.bounces = false
        webView.scrollView.bouncesZoom = false
        webView.loadRequest(request)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    

}

extension RatesViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Showing web view with loaded content
        activityIndicator.stopAnimating()
        webView.isHidden = false
        
        // Adjusting zoom level
        let contentSize = webView.scrollView.contentSize
        let frameSize = webView.frame.size
        let factor = contentSize.width <= contentSize.height ? frameSize.height/contentSize.height : frameSize.width/contentSize.width
        webView.scrollView.setZoomScale(factor, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        // Show error and go back
        CRToastManager.showToast(withTitle: "Error en la conexión.", withSubTitle: "Asegurese de estar conectado a internet.", forError: true)
        _ = navigationController?.popViewController(animated: true)
    }
}
