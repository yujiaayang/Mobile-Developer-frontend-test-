//
//  RegistrationView.swift
//  Mobile Developer(frontend test)
//
//  Created by 阳羽佳 on 6/6/24.
//

import SwiftUI

enum FocusedField {
    case email
    case password
    case confirmpassword
}

struct RegistrationView: View {
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var confirmpasswordText = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var isValidconfirmassword = true
    @State private var presentNextView = false
    @State private var isSecured = true
// proceed
    var canProceed: Bool {
        Validator.validateEmail(emailText) && Validator.validatePassword(passwordText) && validateConfirm(confirmpasswordText)
    }

    @FocusState private var focusedField: FocusedField?

    var body: some View {
            NavigationStack {// navigate to another page
                VStack(alignment: .leading, spacing: 20) {
                    Text("注册")
                        .font(.custom("Alibaba PuHuiTi 3.0", size: 18))
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack(alignment: .leading, spacing: 20) {
                    //"邮箱" Text
                        Text("邮箱")
                            .font(.custom("Alibaba PuHuiTi 3.0", size: 16))
                            .padding(.horizontal)
                    //"邮箱" Input
                        EmailTextField(emailText: $emailText, isValidEmail: $isValidEmail)
                    //"密码" Text
                        Text("密码")
                            .font(.custom("Alibaba PuHuiTi 3.0", size: 16))
                            .padding(.horizontal)
                    //"密码"Input
                        PasswordTextField(passwordText: $passwordText, isValidPassword: $isValidPassword, validatePassword: Validator.validatePassword, errorText: "密码不少于8位，必须包含字母和数字", placeholder: "请输入您的密码")
                    //"密码不少于8位，必须包含字母和数字" Text
                        Text("密码不少于8位，必须包含字母和数字")
                            .font(.custom("Alibaba PuHuiTi 3.0", size: 10))
                            .foregroundColor(passwordText.isEmpty ? Color(.black) : (isValidPassword ? Color(.white) : Color(.white)))
                            .padding(.horizontal)//need to be white when input invalid password,will show this sentence in anther part
                    //"确认密码" Text
                        Text("确认密码")
                            .font(.custom("Alibaba PuHuiTi 3.0", size: 16))
                            .padding(.horizontal)
                    //"确认密码" Input
                        PasswordTextField(passwordText: $confirmpasswordText, isValidPassword: $isValidconfirmassword, validatePassword: validateConfirm, errorText: "您输入的密码不一致！", placeholder: "请确认您的密码")//we just need to check if this is the same as last password
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button("注册") {
                            presentNextView.toggle()// nav to next view
                        }
                        .font(.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .frame(width: 340, height: 50)
                        .foregroundColor(.white)
                        .background(canProceed ? Color("button2") : Color("button1"))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color("button1"), lineWidth: 1)
                        )
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .opacity(canProceed ? 1.0 : 0.5)
                        .disabled(!canProceed)//can click untill all information are valid
                    }
                }
                .navigationDestination(isPresented: $presentNextView) {
                    Text("注册成功！")
                        .font(.custom("Alibaba PuHuiTi 3.0", size: 40))
                        .frame(width: 201, height: 55)
                        .padding(.vertical)
                }
            }
        }


    func validateConfirm(_ password: String) -> Bool {
        passwordText == password
    }
}

struct EmailTextField: View {//“邮箱” Input
    @Binding var emailText: String
    @Binding var isValidEmail: Bool
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack {
            TextField("请输入您的邮箱", text: $emailText)
                .padding()
                .font(.custom("Alibaba PuHuiTi 3.0", size: 16))
                .autocapitalization(.none)//ignore auto capitalization
                .focused($focusedField, equals: .email)
                .background(Color("inputfield"))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(!isValidEmail ? Color("alert") : (focusedField == .email ? Color("button1") : Color("button1")), lineWidth: 1)
                )
                .padding(.horizontal)
                .onChange(of: emailText) { newValue in
                    isValidEmail = Validator.validateEmail(newValue)
                }

            if !isValidEmail {
                HStack {
                    Text("请输入正确的邮箱格式")//this will show "请输入正确的邮箱格式" if email is invalid
                        .font(.custom("Alibaba PuHuiTi 3.0", size: 10))
                        .foregroundColor(Color("alert"))
                        .frame(width: 102, height: 14)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
}

struct PasswordTextField: View {//“密码”&“确认密码“ Input
    @Binding var passwordText: String
    @Binding var isValidPassword: Bool
    @State private var isSecured: Bool = true

    let validatePassword: (String) -> Bool
    let errorText: String
    let placeholder: String
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack{
            HStack {
                // too keep the format consistent
                Group {
                    //password hiding and display
                    if isSecured {
                        SecureField(placeholder, text: $passwordText)
                    } else {
                        TextField(placeholder, text: $passwordText)
                    }
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.leading)

                Spacer()
                
                // Ensure the button aligns to the right
                //button for the two eye.slash
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .foregroundColor(Color("eye"))
                }
                .padding(.trailing)
            }
            .font(.custom("Alibaba PuHuiTi 3.0", size: 16))
            .padding(.vertical)
            .background(Color("inputfield"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isValidPassword ? Color("button1") : Color("alert"), lineWidth: 1)
            )
            .padding(.horizontal)
            
            // the password is not valid or it is empty
            if !isValidPassword && !passwordText.isEmpty {
                Text(errorText)

                    .font(.custom("Alibaba PuHuiTi 3.0", size: 10))
                    .foregroundColor(Color("alert"))
                    .padding(.horizontal)
            }
        }
        .onChange(of: passwordText) { newValue in
            isValidPassword = validatePassword(newValue)
        }
    }
}


// Preview
#Preview {
    RegistrationView()
}
