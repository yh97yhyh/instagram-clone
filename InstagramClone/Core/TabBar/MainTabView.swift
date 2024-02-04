//
//  MainTabView.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Feed")
                .tabItem { Image(systemName: "house") }
            
            Text("Search")
                .tabItem { Image(systemName: "magnifyingglass") }
            
            Text("Upload Post")
                .tabItem { Image(systemName: "plus.square") }
            
            Text("Notification")
                .tabItem { Image(systemName: "heart") }
            
            Text("Profile")
                .tabItem { Image(systemName: "person") }
        }
        .accentColor(.black)
    }
}

#Preview {
    MainTabView()
}
