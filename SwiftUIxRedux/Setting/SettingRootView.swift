//
//  SettingRootView.swift
//  SwiftUIxRedux
//
//  Created by Nic Wu on 2022/9/14.
//

import SwiftUI
import ComposableArchitecture

struct SettingRootView: View {
    var body: some View {
        NavigationView {
            SettingView(store: Store(initialState: SettingState(),
                                     reducer: settingReducer,
                                     environment: SettingEnvironment()))
                .navigationBarTitle("设置")
        }
    }
}

struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView()
    }
}
