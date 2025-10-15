//
//  AuthenticationManager.swift
//  TaskGroove
//
//  Created by Oyewale Favour on 14/10/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import CryptoKit

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage = ""
    
    // For Apple Sign In
    private var currentNonce: String?
    
    init() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = user != nil
        
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isAuthenticated = user != nil
        }
    }
    
    
    // MARK: - Email/Password Authentication
    
    func signUp(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            self.isAuthenticated = true
            print("User signed up : \(result.user.uid)")
        } catch let error as NSError {
            print("Sign up error: \(error)")
            handleAuthError(error)
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            self.isAuthenticated = true
            print("User signed in: \(result.user.uid)")
        } catch let error as NSError {
            print("Sign In error: \(error)")
            handleAuthError(error)
            throw error
            
        }
    }
    
    // MARK: - Google Sign In
    
    func signInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Missing Firebase Client ID"
            print("Missing Firebase ClientID")
            throw NSError(domain: "AuthError", code: -1)
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "No root view controller"
            print("No root view controller")
            throw NSError(domain: "AuthError", code: -1)
            
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                self.errorMessage = "Missing ID Token"
                print("Missing ID Token")
                throw NSError(domain: "AuthError", code: -1)
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
            
            let authResult = try await Auth.auth().signIn(with: credential)
            self.user = authResult.user
            self.isAuthenticated = true
            print("Google Sign in successful: \(authResult.user.uid)")
            
        } catch {
            print("Google Sign in error: \(error)")
            self.errorMessage = "Google sign in failed: \(error.localizedDescription)"
            throw error
        }
    }
    
    // MARK: -  Sign Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.user = nil
            self.isAuthenticated = false
            print(">>> User Signed out")
        } catch {
            self.errorMessage = error.localizedDescription
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Reset Password
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("✅ Password reset email sent")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Password reset error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Apple Sign In
    
    func signInWithApple(authorization: ASAuthorization) async throws {
        print("🍎 signInWithApple called")
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.errorMessage = "Invalid Apple ID credential"
            print("❌ Invalid Apple ID credential")
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple ID credential"])
        }
        
        print("🍎 Apple ID Credential received")
        print("🍎 User ID: \(appleIDCredential.user)")
        
        guard let nonce = currentNonce else {
            self.errorMessage = "Invalid state: No nonce found"
            print("❌ No nonce found")
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid state"])
        }
        
        print("🍎 Nonce found: \(nonce.prefix(10))...")
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            self.errorMessage = "Unable to fetch identity token"
            print("❌ No identity token")
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])
        }
        
        print("🍎 Identity token received")
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            self.errorMessage = "Unable to serialize token string from data"
            print("❌ Unable to serialize token")
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to serialize token"])
        }
        
        print("🍎 Token string created: \(idTokenString.prefix(20))...")
        
        do {
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName
            )
            
            print("🍎 Firebase credential created")
            
            let result = try await Auth.auth().signIn(with: credential)
            self.user = result.user
            self.isAuthenticated = true
            print("✅ Apple sign in successful: \(result.user.uid)")
            
            // Clear the nonce after successful sign in
            self.currentNonce = nil
        } catch let error as NSError {
            print("❌ Firebase Apple sign in error: \(error)")
            print("❌ Error code: \(error.code)")
            print("❌ Error domain: \(error.domain)")
            print("❌ Error description: \(error.localizedDescription)")
            self.errorMessage = "Apple sign in failed: \(error.localizedDescription)"
            throw error
        }
    }
    
    func startSignInWithAppleFlow() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        let hashedNonce = sha256(nonce)
        print("🍎 Generated nonce: \(nonce.prefix(10))...")
        print("🍎 Hashed nonce: \(hashedNonce.prefix(10))...")
        return hashedNonce
    }
    
    
    // MARK: - Helper Methods
    
    private func handleAuthError(_ error: NSError) {
        switch error.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            self.errorMessage = "This email is already in use"
        case AuthErrorCode.invalidEmail.rawValue:
            self.errorMessage = "Invalid email address"
        case AuthErrorCode.weakPassword.rawValue:
            self.errorMessage = "Password is too weak"
        case AuthErrorCode.userNotFound.rawValue:
            self.errorMessage = "No account found with this email"
        case AuthErrorCode.wrongPassword.rawValue:
            self.errorMessage = "Incorrect password"
        case AuthErrorCode.networkError.rawValue:
            self.errorMessage = "Network error. Check your connection"
        default:
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Apple Sign In helpers
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
}
