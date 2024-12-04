import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isSignedUp = false // Simulates successful sign-up

    var body: some View {
        NavigationView {
            VStack {
                TopBar()
                VStack(spacing: 20) {
                    // App Logo
                    Spacer()
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.green)
                        .padding(.bottom, 40)
                    
                    // Full Name Field
                    TextField("Full Name", text: $fullName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(fullName.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                        )
                    
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
                    
                    // Confirm Password Field
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(confirmPassword.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                        )
                    
                    // Sign-Up Button
                    Button(action: handleSignUp) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
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
                    
                    Spacer()
                }
                .padding()
                
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $isSignedUp) {
            ContentView() // Replace with your app's main content view
        }
    }

    // Sign-Up Logic
    func handleSignUp() {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showError = true
            errorMessage = "Please fill in all fields."
        } else if !isValidEmail(email) {
            showError = true
            errorMessage = "Please enter a valid email address."
        } else if password != confirmPassword {
            showError = true
            errorMessage = "Passwords do not match."
        } else {
            // Simulate successful sign-up
            showError = false
            isSignedUp = true
        }
    }

    // Basic Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
