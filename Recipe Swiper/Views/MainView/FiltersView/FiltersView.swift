//
//  FiltersView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var model: MainViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FiltersView()
        .environmentObject(MainViewModel())
}
