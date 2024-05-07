//
//  ViewController.swift
//  FaceIDDemo
//
//  Created by Huei-Der Huang on 2024/5/3.
//

import UIKit
import LocalAuthentication

enum AuthenticationState: String {
    case loggedIn = "Logged in"
    case loggedOut = "Logged out"
}

class ViewController: UIViewController {
    private var state: AuthenticationState = .loggedOut {
        didSet {
            didSetState(state)
        }
    }
    private var context = LAContext()
    
    @IBOutlet weak var useFaceIDButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        testPolicyAvailability()
    }

    @IBAction func useFaceID(_ sender: Any) {
        if state == .loggedOut {
            authenticate()
        } else {
            state = .loggedOut
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray
        useFaceIDButton.clipsToBounds = true
        useFaceIDButton.layer.cornerRadius = 5
    }
    
    private func didSetState(_ state: AuthenticationState) {
        if state == .loggedOut {
            view.backgroundColor = .systemGray
            useFaceIDButton.setTitle("Face ID", for: .normal)
            useFaceIDButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        } else {
            view.backgroundColor = .systemGreen
            useFaceIDButton.setTitle("Log out", for: .normal)
            useFaceIDButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        }
    }
    
    private func testPolicyAvailability() {
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            print(error?.localizedDescription ?? "Can not evaluate policy")
            return
        }
    }
    
    private func authenticate() {
        Task {
            do {
                context = LAContext()
                context.localizedCancelTitle = "Use Password"
                
                try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account")
                state = .loggedIn
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

