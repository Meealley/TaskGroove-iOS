//
//  AppleSignInCoordinator.swift
//  GreetingsApp
//
//  Created by Oyewale Favour on 12/10/2025.
//

import Foundation
import AuthenticationServices
import UIKit

// ✅ Add ObservableObject conformance
class AppleSignInCoordinator: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var onSuccess: ((ASAuthorization) -> Void)?
    var onError: ((Error) -> Void)?
    private var currentNonce: String?
    
    func signIn(nonce: String) {
        print("🍎 AppleSignInCoordinator: signIn called")
        self.currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce
        
        print("🍎 Request created with nonce: \(nonce.prefix(10))...")
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        print("🍎 Performing authorization request...")
        authorizationController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("🍎 Authorization completed successfully")
        onSuccess?(authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Authorization failed with error: \(error)")
        if let authError = error as? ASAuthorizationError {
            print("❌ ASAuthorizationError code: \(authError.code.rawValue)")
        }
        onError?(error)
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("❌ No window found for presentation")
            return UIWindow()
        }
        print("🍎 Returning presentation window")
        return window
    }
}
