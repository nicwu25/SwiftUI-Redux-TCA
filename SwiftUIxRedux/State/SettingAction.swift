//
//  AppAction.swift
//  SwiftUIxRedux
//
//  Created by Nic Wu on 2022/9/15.
//

import Foundation
import ComposableArchitecture

enum SettingAction: BindableAction {
    case binding(BindingAction<SettingState>)
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
}
