//
//  AppEnvironment.swift
//  SwiftUIxRedux
//
//  Created by Nic Wu on 2022/9/15.
//

import Foundation
import ComposableArchitecture

struct SettingEnvironment {
    
    func login(email: String, password: String) -> Effect<User, AppError> {
        LoginRequest(email: email, password: password)
            .publisher
            .eraseToEffect()
    }
}
