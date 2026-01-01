import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("Sign in background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 36) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sign in")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(-1)
                    
                    Text("You'll find what you're looking for in the ocean of movies")
                        .font(.system(size: 16))
                        .foregroundColor(Color(white: 0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                        
                        TextField("", text: $email, prompt: Text("Enter your email").foregroundColor(Color.white.opacity(0.4)))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .cornerRadius(6)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 0) {
                            Group {
                                if isPasswordVisible {
                                    TextField("", text: $password, prompt: Text("Enter your password").foregroundColor(Color.white.opacity(0.4)))
                                } else {
                                    SecureField("", text: $password, prompt: Text("Enter your password").foregroundColor(Color.white.opacity(0.4)))
                                }
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .textContentType(.password)
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .frame(width: 44, height: 44)
                            }
                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 4)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .cornerRadius(6)
                    }
                }
                
                Button(action: {
                    signIn()
                }) {
                    Text("Sign in")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(red: 245/255, green: 200/255, blue: 66/255))
                        .cornerRadius(6)
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 48)
            .padding(.vertical, 56)
            .frame(maxWidth: 480)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.75))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial.opacity(0.3))
                    )
            )
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
    
    func signIn() {
        onSignIn?()
    }
}

#Preview {
    SignInView()
}
