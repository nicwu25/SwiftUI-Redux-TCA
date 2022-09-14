//
//  SettingView.swift
//  SwiftUIxRedux
//
//  Created by Nic Wu on 2022/9/14.
//

import SwiftUI
import Combine

class Settings: ObservableObject {

    enum AccountBehavior: CaseIterable {
        case register, login
    }

    enum Sorting: CaseIterable {
        case id, name, color, favorite
    }
    
    private var disposeBag = Set<AnyCancellable>()

    @Published var accountBehavior = AccountBehavior.login
    @Published var email = ""
    @Published var password = ""
    @Published var verifyPassword = ""

    @Published var showEnglishName = true
    @Published var sorting = Sorting.id
    @Published var showFavoriteOnly = false
    
    @Published var loginUser: User?
    @Published var loginRequesting = false
    @Published var loginError: AppError?
    
    func login() {
        
        guard !loginRequesting else { return }
        
        loginRequesting = true
        
        LoginRequest(email: email, password: password).publisher
            .sink { [weak self] complete in
                if case .failure(let error) = complete {
                    self?.loginError = error
                    self?.loginRequesting = false
                }
            } receiveValue: { [weak self] user in
                self?.loginUser = user
                self?.loginRequesting = false
            }.store(in: &disposeBag)
    }
}

struct SettingView: View {
    
    @ObservedObject var settings = Settings()
    
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        .alert(item: $settings.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            if settings.loginUser == nil {
                Picker(selection: $settings.accountBehavior, label: Text("")) {
                    ForEach(Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("电子邮箱", text: $settings.email)
                SecureField("密码", text: $settings.password)
                if settings.accountBehavior == .register {
                    SecureField("确认密码", text: $settings.verifyPassword)
                }
                if settings.loginRequesting {
                    Text("登陸中...")
                } else {
                    Button(settings.accountBehavior.text) {
                        print("登录/注册")
                        settings.login()
                    }
                }
            } else {
                Text(settings.loginUser!.email)
                Button("注销") {
                    print("注销")
                }
            }
        }
    }

    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: $settings.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: $settings.sorting, label: Text("排序方式")) {
                ForEach(Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: $settings.showFavoriteOnly) {
                Text("只显示收藏")
            }
        }
    }

    var actionSection: some View {
        Section {
            Button(action: {
                print("清空缓存")
            }) {
                Text("清空缓存").foregroundColor(.red)
            }
        }
    }
}

extension Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
