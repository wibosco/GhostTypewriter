//
//  MainView.swift
//  Example
//
//  Created by William Boles on 21/10/2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ForwardRevealView()
                .tabItem {
                    Label("Forward Reveal", systemImage: "forward.fill")
                }
            BackwardHideView()
                .tabItem {
                    Label("Backward Hide", systemImage: "backward.fill")
                }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
