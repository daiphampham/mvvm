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
        // Bind url in case load content from url.
        viewModel.rxURL ~> self.wkWebView.rx.url => disposeBag
        // Bind source in case load content from html file.
        viewModel.rxSource ~> self.wkWebView.rx.sourceHtml => disposeBag
        
        viewModel.rxCanGoBack ~> self.btnBack.rx.isEnabled => disposeBag
        viewModel.rxCanGoForward ~> self.btnForward.rx.isEnabled => disposeBag
        viewModel.rxIsLoading.subscribe(onNext: { (value) in
            if value {
                self.lbLoading.text = "Loading"
            } else {
                self.lbLoading.text = "Loaded"
            }
        }) => disposeBag
        
        //Subcribe estimated progress
        viewModel.rxEstimatedProgress.subscribe(onNext: { (prgress) in
            self.lbLoading.text = "Loading \(Int(prgress * 100))%"
        }) => disposeBag
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubviewToFront(btnBack)
        self.view.bringSubviewToFront(btnForward)
        self.view.bringSubviewToFront(lbLoading)
        
        if viewModel is EvaluateJavaScriptWebViewModel {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.evaluateJavaScript("presentAlert()")
            }
        }
    }
    
    @objc func goBack() {
        self.wkWebView.goBack()
     }
     
     @objc func goForward() {
         self.wkWebView.goForward()
     }
    
}


//MARK: ViewModel For BaseWebView Examples
class IntroductionPageViewModel: BaseWebViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")
    let rxURL = BehaviorRelay<URL?>(value: nil)
    
    
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Table Of Contents"
        let url = URL(string: "https://github.com/tienpm-0557/mvvm/blob/AddBaseNonGeneric/README.md")!

        rxPageTitle.accept(title)
        rxURL.accept(url)
    }
    
    override func webView(_ webView: WKWebView, estimatedProgress: Double) {
        self.rxEstimatedProgress.accept(estimatedProgress)
        print("DEBUG: estimatedProgress \(estimatedProgress)")
    }
}


class AlertWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Alert Panel With message"
        let url = URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_alert")!
        
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

}

class ConfirmAlertWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Confirm Alert"
        let url = URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_confirm2")!
        
        rxPageTitle.accept(title)
        rxURL.accept(url)
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
}

class AuthenticationWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Authentication"
        let url = URL(string: "https://jigsaw.w3.org/HTTP/Basic/")!
        
        rxPageTitle.accept(title)
        rxURL.accept(url)
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
}


class FailNavigationWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Fail Provisional Navigation"
        let url = URL(string: "https://thiswebsiteisnotexisting.com")!
        
        rxPageTitle.accept(title)
        rxURL.accept(url)
    }
    
    override func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "FailProvisionalNavigation", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navigationService.push(to: alert, options: .modal())
    }
}

class EvaluateJavaScriptWebViewModel: IntroductionPageViewModel {
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Evaluate JavaScript"
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <title>Invoke Javascript function</title>
        </head>
        <body>

        <h1>Invoke Javascript function</h1>
        <h1>Just Press 'Invoke' at top right corner.</h1>
        <h1>After that, pay attention to your console.</h1>

        <script>
        function presentAlert() {
            return "🎊🎊🎊Hey! you just invoke me🎉🎉🎉"
        }
        </script>

        </body>
        </html>
        """

        
        rxPageTitle.accept(title)
        rxSourceType.accept(WebViewSuorceType.html.rawValue)
        rxSource.accept(html)
        
    }
    
    override func webView(_ webView: WKWebView, evaluateJavaScript: (event: Any?, error: Error?)?) {
        if let event = evaluateJavaScript?.event as? String {
            let alert = UIAlertController(title: "Evaluate Java Script", message: event, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            navigationService.push(to: alert, options: .modal())
        }
    }
}

