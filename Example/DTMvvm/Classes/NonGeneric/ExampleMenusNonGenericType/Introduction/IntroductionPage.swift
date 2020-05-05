//
//  IntroductionPage.swift
//  DTMvvm_Example
//
//  Created by pham.minh.tien on 5/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DTMvvm
import DTMvvm
import RxCocoa
import RxSwift
import Action

class IntroductionPage: BasePage {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? IntroductionPageViewModel else { return }
        viewModel.rxPageTitle ~> rx.title => disposeBag
    }
    
}


//MARK: ViewModel For MVVM Examples
class IntroductionPageViewModel: BaseViewModel {
    
    let rxPageTitle = BehaviorRelay(value: "")
    
    override func react() {
        super.react()
        let title = (self.model as? IntroductionModel)?.title ?? "Table Of Contents"
        rxPageTitle.accept(title)
    }
}

