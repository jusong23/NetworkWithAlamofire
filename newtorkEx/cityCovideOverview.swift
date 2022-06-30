//
//  cityCovideOverview.swift
//  newtorkEx
//
//  Created by 이주송 on 2022/06/30.
//

import Foundation

// JSON 파일을 응답받을 구조체

struct CityCovidOverview: Codable {
    let korea: CovideOverView
    let seoul: CovideOverView
    let busan: CovideOverView
}

struct CovideOverView: Codable {
    let totalCase: String
    let newCase: String
}
