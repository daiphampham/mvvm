//
//  IntroductionPage.swift
//  DTMvvm_Example
//
//  Created by pham.minh.tien on 5/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DTMvvm
import RxCocoa
import RxSwift
import WebKit
import Action

class IntroductionPage: BaseWebView {
    @IBOutlet private var btnBack: UIButton!
    @IBOutlet private var btnForward: UIButton!
    @IBOutlet private var lbLoading: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? IntroductionPageViewModel else { return }
        btnBack.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
        btnForward.addTarget(self, action: #selector(self.goForward), for: UIControl.Event.touchUpInside)
        
        viewModel.rxPageTitle ~> rx.title => disposeBag
        viewModel.rxURL ~> self.wkWebView.rx.url => disposeBag
        viewModel.rxCanGoBack ~> self.btnBack.rx.isEnabled => disposeBag
        viewModel.rxCanGoForward ~> self.btnForward.rx.isEnabled => disposeBag
        viewModel.rxIsLoading.subscribe(onNext: { (value) in
            if value {
                self.lbLoading.text = "Loading"
            } else {
                self.lbLoading.text = "Loaded"
            }
        }) => disposeBag
        self.wkWebView.goBack()
        
        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubviewToFront(btnBack)
        self.view.bringSubviewToFront(btnForward)
        self.view.bringSubviewToFront(lbLoading)
    }
    
    @objc func goBack() {
        self.wkWebView.goBack()
     }
     
     @objc func goForward() {
         self.wkWebView.goForward()
     }
    
}


//MARK: ViewModel For MVVM Examples
class IntroductionPageViewModel: BaseWebViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")
    let rxURL = BehaviorRelay<URL?>(value: nil)
    
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Table Of Contents"
        let url = URL(string: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md")!
        
        // Alert
//        let url = URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_alert")!
        
        //Confirm Alert
//        let url = URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_confirm2")!
        
        // Authentication
//        let url = URL(string: "https://jigsaw.w3.org/HTTP/Basic/")!
        
        // FailProvisionalNavigation
//        let url = URL(string: "https://thiswebsiteisnotexisting.com")!
        
        // Link error
//        let url = URL(string: "https://thiswebsiteisnotexisting.com")!
        
        
        rxPageTitle.accept(title)
        rxURL.accept(url)
    }
    
    
    
    override func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "runJavaScriptAlertPanelWithMessage", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        navigationService.push(to: alert, options: .modal())
        
    }
    
    override func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "JavaScriptConfirm", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        navigationService.push(to: alert, options: .modal())
    }
    
    override func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        /*
         The correct credentials are:
         
         user = guest
         password = guest
         
        You might want to start with the invalid credentials to get a sense of how this code works
        */
        let credential = URLCredential(user: "guest", password: "guest", persistence: URLCredential.Persistence.forSession)
        challenge.sender?.use(credential, for: challenge)
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
    }
    
    override func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "FailProvisionalNavigation", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navigationService.push(to: alert, options: .modal())
    }
}

