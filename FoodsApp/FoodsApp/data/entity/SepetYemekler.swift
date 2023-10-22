//
//  SepetYemekler.swift
//  FoodsApp
//
//  Created by Damla Sahin on 21.10.2023.
//

import Foundation

class SepetYemekler: Codable {
    var sepet_yemek_id: String?
    var yemek_adi: String?
    var yemek_fiyat: String?
    var yemek_resim_adi: String?
    var yemek_siparis_adet: String?
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
        yemek_siparis_adet = try container.decodeIfPresent(String.self, forKey: .yemek_siparis_adet)
        yemek_fiyat = try container.decodeIfPresent(String.self, forKey: .yemek_fiyat)
        yemek_kullanici_adi = try container.decodeIfPresent(String.self, forKey: .yemek_kullanici_adi)

    }
}

