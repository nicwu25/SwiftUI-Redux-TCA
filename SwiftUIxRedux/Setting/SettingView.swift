//
//  SettingView.swift
//  SwiftUIxRedux
//
//  Created by Nic Wu on 2022/9/14.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    
    let store: Store<SettingState, SettingAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                accountSection
                optionSection
                actionSection
            }
            .alert(item: viewStore.binding(\.$loginError)) { error in
                Alert(title: Text(error.localizedDescription))
            }
        }
    }

    var accountSection: some View {
        WithViewStore(store) { viewStore in
            Section(header: Text("账户")) {
                if viewStore.loginUser == nil {
                    Picker(selection: viewStore.binding(\.$accountBehavior), label: Text("")) {
                        ForEach(SettingState.AccountBehavior.allCases, id: \.self) {
                            Text($0.text)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    TextField("电子邮箱", text: viewStore.binding(\.$email))
                    SecureField("密码", text: viewStore.binding(\.$password))
                    if viewStore.accountBehavior == .register {
                        SecureField("确认密码", text: viewStore.binding(\.$verifyPassword))
                    }
                    if viewStore.loginRequesting {
                        Text("登陸中...")
                    } else {
                        Button(viewStore.accountBehavior.text) {
                            print("登录/注册")
                            viewStore.send(.login(email: viewStore.email, password: viewStore.password))
                        }
                    }
                } else {
                    Text(viewStore.loginUser!.email)
                    Button("注销") {
                        print("注销")
                    }
                }
            }
        }
    }

    var optionSection: some View {
        WithViewStore(store) { viewStore in
            Section(header: Text("选项")) {
                Toggle(isOn: viewStore.binding(\.$showEnglishName)) {
                    Text("显示英文名")
                }
                Picker(selection: viewStore.binding(\.$sorting), label: Text("排序方式")) {
                    ForEach(SettingState.Sorting.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                Toggle(isOn: viewStore.binding(\.$showFavoriteOnly)) {
                    Text("只显示收藏")
                }
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

extension SettingState.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension SettingState.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .init(), reducer: settingReducer, environment: SettingEnvironment())
        SettingView(store: store)
    }
}
