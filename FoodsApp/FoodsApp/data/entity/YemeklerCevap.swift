//
//  YemeklerCevap.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import Foundation

class YemeklerCevap : Codable {
    var yemekler:[Yemekler]?
    var success:Int?
}

class SepetCevap: Codable {
    var sepetYemekler: [SepetYemekler]?
    var success: Int?

    enum CodingKeys: String, CodingKey {
        case sepetYemekler = "sepet_yemekler"
        case success
    }
}

