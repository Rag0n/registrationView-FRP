//
//  LoginViewController.swift
//  RegistrationView-FRP-example
//
//  Created by Александр on 21.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailValidationLabel.text = "Not a valid email adress"
        passwordValidationLabel.text = "Password has to be at least \(minimalPasswordlength) characters"

        emailTextField.rx_text
            .subscribeNext { print($0) }
            .addDisposableTo(disposeBag)
        
        // rx_text just sends text
        let emailIsValid = emailTextField.rx_text
            .map(isValidEmail)
            .shareReplay(1)
        
        /* shareReplay
            ensure that all observers see the same sequence of emitted items,
            even if they subscribe after the Observable has begun emitting items
        */
        
        let passwordIsValid = passwordTextField.rx_text
            .map(isValidPassword)
            .shareReplay(1)
        
        let everythingIsValid = Observable.combineLatest(emailIsValid, passwordIsValid) {
            $0 && $1
        }
        
        // if login is not valid, then password textfield is hidden
        emailIsValid
            .bindTo(passwordTextField.rx_enabled)
            .addDisposableTo(disposeBag)
        
        // if login is valid, then error message is hidden
        emailIsValid
            .bindTo(emailValidationLabel.rx_hidden)
            .addDisposableTo(disposeBag)
        
        // if password is valid, then error message is hidden
        passwordIsValid
            .bindTo(passwordValidationLabel.rx_hidden)
            .addDisposableTo(disposeBag)
        
        // if everything is valid, then button is enabled
        everythingIsValid
            .bindTo(loginButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
        // when button is tapped, show alert
        loginButton.rx_tap
//            .subscribeNext(showAlert)
            .subscribeNext {
                self.showAlert()
                // do something else
            }
            .addDisposableTo(disposeBag)
        
    }
    
    /*
        Release resources after deallocating VC
    */
    private let disposeBag = DisposeBag()
    
    private func showAlert() {
        let ac = UIAlertController(title: "Login button was tapped", message: "and now you can see this beautiful alert view", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
}

