//
//  Yemekler.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import Foundation

class Yemekler: Codable {
    var sepet_yemek_id: String?
    var yemek_adi: String?
    var yemek_fiyat: Int?
    var yemek_resim_adi: String?
    var yemek_siparis_adet: Int?
    var yemek_kullanici_adi: String?

    enum CodingKeys: String, CodingKey {
        case sepet_yemek_id
        case yemek_adi
        case yemek_fiyat
        case yemek_resim_adi
        case yemek_siparis_adet
        case yemek_kullanici_adi
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sepet_yemek_id = try container.decodeIfPresent(String.self, forKey: .sepet_yemek_id)
        yemek_adi = try container.decodeIfPresent(String.self, forKey: .yemek_adi)
        yemek_resim_adi = try container.decodeIfPresent(String.self, forKey: .yemek_resim_adi)
        yemek_siparis_adet = try container.decodeIfPresent(Int.self, forKey: .yemek_siparis_adet)
        yemek_kullanici_adi = try container.decodeIfPresent(String.self, forKey: .yemek_kullanici_adi)

        // Custom handling for yemek_fiyat
        if let fiyatString = try container.decodeIfPresent(String.self, forKey: .yemek_fiyat), let fiyat = Int(fiyatString) {
            yemek_fiyat = fiyat
        }
    }
}

