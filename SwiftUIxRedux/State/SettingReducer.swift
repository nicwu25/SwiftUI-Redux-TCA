//
//  AppReducer.swift
//  SwiftUIxRedux
//
//  Created by Nic Wu on 2022/9/15.
//

import Foundation
import ComposableArchitecture

let settingReducer = Reducer<SettingState, SettingAction, SettingEnvironment> { state, action, envi in
    
    switch action {
    case .binding:
        return .none
    case .login(email: let email, password: let password):
        
        guard !state.loginRequesting else { return .none }
        
        state.loginRequesting = true
        
        return envi.login(email: email, password: password)
            .catchToEffect(SettingAction.accountBehaviorDone)
        
    case .accountBehaviorDone(let result):
        
        state.loginRequesting = false
        
        switch result {
        case .success(let user):
            state.loginUser = user
        case .failure(let error):
            state.loginError = error
        }
        
        return .none
    }
}
.binding()
