import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false // Simulates login success
    
    

    var body: some View {
        NavigationView {
            VStack {
                TopBar()
                VStack(spacing: 20) {
                    // App Logo
                    Spacer()
                    Image(systemName: "hands.sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.blue)
                        .padding(.bottom, 40)
                        .offset(y: -50)
                    
                    // Email Field
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(email.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                        )
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(password.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                        )
                    
                    // Login Button
                    Button() {
                        Task {
                            await handleLogin()
                        }
                    }label:{
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                    
                    // Error Message
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top, 10)
                    }
                    
                    // Forgot Password & Register Links
                    HStack {

                        Spacer()
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding()
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            ContentView(contextUser: authManager.currentUser!.role) // Main app view after login
        }
        
    }

    // Login Logic
    func handleLogin() async {
        do {
            if email.isEmpty || password.isEmpty {
                showError = true
                errorMessage = "Please fill in all fields."
            } else if !isValidEmail(email) {
                showError = true
                errorMessage = "Please enter a valid email address."
            } else {
                // Simulate successful login
                showError = false
                print("Logging in as \(email)")
                try await authManager.signIn(withEmail: email, password: password)
                print(authManager.currentUser!.role)
                isLoggedIn = true
            }
        } catch {
            print("Failed to log in user")
        }
        
    }

    // Basic Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
