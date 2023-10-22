//
//  YemekDetayViewModel.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import Foundation
import RxSwift

class SepetViewModel {
    var krepo = YemeklerDaoRepository()
    var yemeklerListesi = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    
    init() {
        yemeklerListesi = krepo.sepetYemekListesi
    }
    
    func sepetiYukle(){
        krepo.sepetiYukle()
    }
    
    func sil(sepet_yemek_id:Int, kullanici_adi: String){
        krepo.sil(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
        sepetiYukle()
    }
    
    func sepetiTemizle(kullanici_adi: String) {
        let disposable = yemeklerListesi.subscribe(onNext: { sepetYemekleri in
            sepetYemekleri.forEach { sepetYemek in
                if let sepetYemekId = Int(sepetYemek.sepet_yemek_id!) {
                    self.krepo.sil(sepet_yemek_id: sepetYemekId, kullanici_adi: kullanici_adi)
                }
            }
        })
        sepetiYukle()
    }
    
    func kaydet(yemek_adi:String,yemek_fiyat:Int,yemek_resim_adi:String, yemek_siparis_adet: Int, kullanici_adi: String){
        krepo.kaydet(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
}

