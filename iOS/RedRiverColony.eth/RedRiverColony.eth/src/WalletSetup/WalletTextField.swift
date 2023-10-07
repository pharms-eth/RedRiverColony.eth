//
//  WalletTextField.swift
//  RedRiverColony.eth
//
//  Created by Daniel Bell on 10/1/23.
//

import SwiftUI
struct WalletTextField: View {
    var label: String
    @Binding var text: String
    var validate: Bool
    @State private var isSecured: Bool = true
    @State private var passwordError: String?

    func validate(password: String) {

        guard !password.isEmpty else {
            passwordError = nil
            return
        }

        //At least 8 characters
        if password.count < 8 {
            passwordError = "Must Be Min Length 8"
            return
        }

        //At least one digit
        if password.range(of: #".*[0-9]+.*"#, options: .regularExpression) == nil {
            passwordError = "Must Contain At Least 1 digit"
            return
        }

        //At least one letter
        if password.range(of: #".*[a-zA-Z]+.*"#, options: .regularExpression) == nil {
            passwordError = "Must Contain At Least 1 Letter"
            return
        }

        //At least one special Character
        if password.range(of: #".*[!&^%$#@()._-]+.*"#, options: .regularExpression) == nil {
            passwordError = "Must Contain At Least 1 of !&^%$#@()._-"
            return
        }

        //No whitespace charcters
        if password.range(of: #"\s+"#, options: .regularExpression) != nil {
            passwordError = "Must Not Contain Spaces"
            return
        }

        passwordError = nil
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: nil) {
                HStack {
                    Text(label)
                        .foregroundColor(Color.labelForeground)
                        .font(.system(size: 12, weight: .light))
                        .padding(.bottom, 2)
                    Spacer()
                    if let passwordError = passwordError {
                        Text(passwordError)
                    }
                }
                Group {
                    if isSecured {
                        SecureField("Password", text: $text)
                    } else {
                        TextField("Password", text: $text)
                            .onChange(of: text) { newValue in
                                if validate {
                                    validate(password: newValue)
                                }
                            }
                            .onSubmit {
                                if validate {
                                    validate(password: text)
                                }
                            }
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                        .disableAutocorrection(true)
                    }
                }
                    .padding()
                    .background(Color.textBackground)
                    .foregroundColor(Color.textForeground)
            }
            Image(systemName: isSecured ? "eye.slash" : "eye")
                .foregroundColor(.gray)
                .onTapGesture {
                    isSecured.toggle()
                }
        }
    }
}
