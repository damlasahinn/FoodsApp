//
//  AnasayfaViewModel.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    var krepo = YemeklerDaoRepository()
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init(){
        yemeklerListesi = krepo.yemeklerListesi
    }
    
    func ara(aramaKelimesi:String){
        krepo.ara(aramaKelimesi: aramaKelimesi)
    }
    
    func sil(sepet_yemek_id:Int, kullanici_adi: String){
        krepo.sil(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
        yemekleriYukle()
    }
    
    func yemekleriYukle(){
        krepo.yemekleriYukle()
    }
}
