//
//  YemeklerDaoRepository.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import Foundation
import RxSwift
import Alamofire

class YemeklerDaoRepository {//Dao : Database Access Object
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepetYemekListesi = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    //http://kasimadalan.pe.hu/yemekler/tum_yemekler.php
    
    func kaydet(yemek_adi:String, yemek_resim_adi:String, yemek_fiyat:Int, yemek_siparis_adet:Int, kullanici_adi:String){
        let params: Parameters = ["yemek_adi": yemek_adi, "yemek_resim_adi": yemek_resim_adi, "yemek_fiyat": yemek_fiyat, "yemek_siparis_adet": yemek_siparis_adet, "kullanici_adi": kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response { response in
            do{
                if let data = response.data {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("--- INSERT ---")
                    print("Basari : \(cevap.success!)")
                    print("Message : \(cevap.message!)")
                    
                }
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func guncelle(sepet_yemek_id:Int,yemek_adi:String,yemek_tel:String){
        let params: Parameters = ["sepet_yemek_id": sepet_yemek_id, "yemek_adi": yemek_adi, "yemek_tel": yemek_tel]
        AF.request("http://kasimadalan.pe.hu/yemekler/update_yemekler.php", method: .post, parameters: params).response { response in
            do{
                if let data = response.data {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("--- UPDATE ---")
                    print("Basari : \(cevap.success!)")
                    print("Message : \(cevap.message!)")
                    
                }
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func ara(aramaKelimesi: String) {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get, parameters: nil).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let liste = cevap.yemekler {
                        self.yemeklerListesi.onNext(liste)
                    }
                    
                    let rawResponse = try JSONSerialization.jsonObject(with: data)  // webservisten pilgi geliyo mu kontrol için
                    //print(rawResponse)
                }catch{
                    print(error.localizedDescription)
                }
            }
            
        }
    }

    
    func sil(sepet_yemek_id:Int, kullanici_adi:String){
        let params: Parameters = ["sepet_yemek_id": sepet_yemek_id, "kullanici_adi": kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response { response in
            do{
                if let data = response.data {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("--- DELETE ---")
                    print("Basari : \(cevap.success!)")
                    print("Message : \(cevap.message!)")
                    
                }
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func sepetiYukle(){
        let params: Parameters = ["kullanici_adi": "damla"]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do{
                    if let data = response.data {
                        let jsonString = String(data: data, encoding: .utf8)
                        print("Raw JSON Data: \(jsonString ?? "No data")")
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(SepetCevap.self, from: data)
                      
                        if let liste = decodedData.sepetYemekler {
                            self.sepetYemekListesi.onNext(liste)
                        }
                        
                        let rawResponse = try JSONSerialization.jsonObject(with: data)  // webservisten pilgi geliyo mu kontrol için
                        //print(rawResponse)
                    } catch {
                        print("JSON decoding error: \(error)")
                    }
                    
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func yemekleriYukle(){
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do{
                    if let data = response.data {
                        let jsonString = String(data: data, encoding: .utf8)
                        print("Raw JSON Data: \(jsonString ?? "No data")")
                    }

                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(YemeklerCevap.self, from: data)
                        // Process decodedData
                        if let liste = decodedData.yemekler {
                            self.yemeklerListesi.onNext(liste)
                        }
                        
                        let rawResponse = try JSONSerialization.jsonObject(with: data)  // webservisten pilgi geliyo mu kontrol için
                        //print(rawResponse)
                    } catch {
                        print("JSON decoding error: \(error)")
                    }

                    
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}
