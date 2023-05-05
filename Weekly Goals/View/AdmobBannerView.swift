//
//  AdmobBannerView.swift
//  Weekly Goals
//
//  Created by 島田雄介 on 2023/05/05.
//

import SwiftUI

struct AdmobBannerView: View {
    var body: some View {
        HStack {
            AdmobBannerViewController().frame(width: 320, height: 50)
        }
    }
}

struct AdmobBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AdmobBannerView()
    }
}

