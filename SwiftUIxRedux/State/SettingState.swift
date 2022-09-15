//
//  AppState.swift
//  SwiftUIxRedux
//
//  Created by Nic Wu on 2022/9/15.
//

import Foundation
import ComposableArchitecture

/*
 Referencing initializer 'init(_:content:file:line:)' on 'WithViewStore' requires that 'SettingState' conform to 'Equatable'
 
 TCA State 必須符合Equatable協議，表示每次我們執行狀態更改時，會執行相等檢查以重新計算，查看是否重新加載其WithViewStore主體。
 */
struct SettingState: Equatable {
    
    enum AccountBehavior: CaseIterable, Equatable {
        case register, login
    }

    enum Sorting: CaseIterable, Equatable {
        case id, name, color, favorite
    }

    @BindableState var accountBehavior = AccountBehavior.login
    @BindableState var email = ""
    @BindableState var password = ""
    @BindableState var verifyPassword = ""

    @BindableState var showEnglishName = true
    @BindableState var sorting = Sorting.id
    @BindableState var showFavoriteOnly = false
    
    @BindableState var loginUser: User?
    @BindableState var loginRequesting = false
    @BindableState var loginError: AppError?
}
