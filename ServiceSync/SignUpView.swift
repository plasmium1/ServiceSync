import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var fullName = ""
    @State private var email = ""
    @State private var age = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isSignedUp = false // Simulates successful sign-up
    @State private var accountType: AccountType = .student // Default to Student account
    @State private var newUser: User? = nil

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
                    
                    // Account Type Selector
                    Picker("Account Type", selection: $accountType) {
                        Text("Student").tag(AccountType.student)
                        Text("Manager").tag(AccountType.manager)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 20)
                    
                    
                    // Full Name Field
                    if (accountType == AccountType.student) {
                        TextField("Full Name", text: $fullName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(fullName.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                            )
                    } else if (accountType == AccountType.manager) {
                        TextField("Program Name", text: $fullName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(fullName.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                            )
                    }
                    
                    
                    
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
                    
                    if (accountType == AccountType.student) {
                        // Age Field
                        TextField("Age", text: $age)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(email.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                            )
                    } else if (accountType == AccountType.manager) {
                        TextField("Telephone", text: $age)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(email.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                            )
                    }
                    
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(password.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                        )
                    
                    // Confirm Password Field
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(confirmPassword.isEmpty ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                        )
                    
                    // Sign-Up Button
                    Button() {
                        Task {
                            await handleSignUp()
                        }
                    }label:{
                        Text("Sign Up as \(accountType.rawValue.capitalized)")
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
            
            ContentView(contextUser: accountType.rawValue, isLoggedIn: $isSignedUp) // Replace with your app's main content view
        }
    }

    // Sign-Up Logic
    func handleSignUp() async {
        do {
            print("Signing up")
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
                print("Signed up as \(accountType.rawValue.capitalized)")
                print(AccountType.student.rawValue)
                print(AccountType.manager.rawValue)
                if (accountType.rawValue == AccountType.student.rawValue) {
                    let a: Int? = Int(age)
                    print("Began creating student")
                    
                    try await authManager.createStudentUser(withEmail: email, password: password, name: fullName, age: a!, telephone: a!)
                    print("Finished creating student")
                } else if (accountType.rawValue == AccountType.manager.rawValue) {
                    let a: Int? = Int(age)
                    try await authManager.createManagerUser(withEmail: email, password: password, name: fullName, age: a!, telephone: a!)
                }
                isSignedUp = true
            }
        } catch {
            print("Failed to create new user")
        }
        
    }

    // Basic Email Validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

// MARK: - AccountType Enum
enum AccountType: String {
    case student = "student"
    case manager = "manager"
}

// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
