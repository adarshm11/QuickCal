
import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var signUpViewModel = SignupViewModel()
    @State private var isSignUpPressed = false
    @State private var isLoginPressed = false
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var isHoveringLogin = false
    @State private var isHoveringSignUp = false
    
    private var sharedEmail: Binding<String> {
        Binding(
            get: { loginViewModel.email },
            set: { new in
                loginViewModel.email = new
                signUpViewModel.email = new
            }
        )
    }
    
    private var sharedPassword: Binding<String> {
        Binding(
            get: { loginViewModel.password },
            set: { new in
                loginViewModel.password = new
                signUpViewModel.password = new
            }
        )
    }
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                
                Spacer()
                
                Text("Welcome to QuickCal!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Text("Your personal calendar assistant")
                    .font(.title3)
                    .foregroundColor(Color.gray)
                
                Text("Log in to continue")
                    .foregroundColor(.black)
                    .font(.headline)
                      
                ZStack(alignment: .leading) {
                    if sharedEmail.wrappedValue.isEmpty {
                        Text("Email")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                    }
                    TextField("", text: sharedEmail)
                        .textContentType(.emailAddress)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .frame(height: 44)
                        .frame(maxWidth: 320)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5)))
                        .onSubmit {
                            guard !signUpViewModel.email.isEmpty && !signUpViewModel.password.isEmpty else {
                                print("Incomplete info")
                                return
                            }
                            signUpViewModel.handleLogic()
                        }
                }
                .background(Color.white)
                
                ZStack(alignment: .leading) {
                    if sharedPassword.wrappedValue.isEmpty {
                        Text("Password")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                    }
                    SecureField("", text: sharedPassword)
                        .textContentType(.password)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .frame(height: 44)
                        .frame(maxWidth: 320)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5)))
                        .onSubmit {
                            guard !loginViewModel.email.isEmpty && !loginViewModel.password.isEmpty else {
                                print("Incomplete info")
                                return
                            }
                            loginViewModel.handleLogin(appViewModel: appViewModel)
                        }
                }
                .background(Color.white)
                
                HStack(spacing: 20) {
                    Button(action: {
                        isSignUpPressed = false
                        isLoginPressed = true
                        loginViewModel.handleLogin(appViewModel: appViewModel)
                    }) {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 120, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isHoveringLogin ? Color.red.opacity(0.8) : Color.red)
                            )
                            .scaleEffect(isHoveringLogin ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: isHoveringLogin)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        isHoveringLogin = hovering
                    }
                    
                    Button(action: {
                        isSignUpPressed = true
                        isLoginPressed = false
                        signUpViewModel.handleLogic()
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .frame(width: 120, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(isHoveringSignUp ? Color.red.opacity(0.1) : Color.white)
                                    )
                            )
                            .scaleEffect(isHoveringSignUp ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: isHoveringSignUp)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        isHoveringSignUp = hovering
                    }
                }
                .padding(.top, 8)
                
                if isSignUpPressed {
                    Text(signUpViewModel.responseMessage)
                        .foregroundColor(.red)
                } else {
                    Text(loginViewModel.responseMessage)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
