//
//  YemekKayit.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import UIKit

class YemekKayit: UIViewController {

    @IBOutlet weak var imageYemek: UIImageView!
    @IBOutlet weak var labelYemekAdi: UILabel!
    @IBOutlet weak var labelYemekFiyati: UILabel!
    @IBOutlet weak var labelYemekAdet: UILabel!
    @IBOutlet weak var labelToplamFiyat: UILabel!
    var viewModel = YemekKayitViewModel()
    
    var yemek:Yemekler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let y = yemek {
            labelYemekAdi.text = y.yemek_adi
            if let imageName = y.yemek_resim_adi, let imageURL = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)") {
                URLSession.shared.dataTask(with: imageURL) { data, _, error in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageYemek.image = image
                        }
                    }
                }.resume()
            } else {
                imageYemek.image = UIImage(named: "defaultImage")
            }

            if let fiyat = y.yemek_fiyat {
                self.labelYemekFiyati.text = String(fiyat)
                self.labelToplamFiyat.text = String(fiyat)
            } else {
                self.labelYemekFiyati.text = "N/A"
                self.labelToplamFiyat.text = "N/A"
            }
        }
    }
    
    @IBAction func adetArttirAction(_ sender: Any) {
        if let adetString = labelYemekAdet.text, let fiyatString = labelYemekFiyati.text,
           let adetInt = Int(adetString), let fiyatInt = Int(fiyatString) {

            let newAdet = adetInt + 1
            let newTotalFiyat = newAdet * fiyatInt

            labelYemekAdet.text = String(newAdet)
            labelToplamFiyat.text = String(newTotalFiyat)
        }
    }

    @IBAction func adetAzaltAction(_ sender: Any) {
        if let adetString = labelYemekAdet.text, let fiyatString = labelYemekFiyati.text,
           let adetInt = Int(adetString), let fiyatInt = Int(fiyatString) {

            let newAdet = max(adetInt - 1, 1)
            let newTotalFiyat = newAdet * fiyatInt

            labelYemekAdet.text = String(newAdet)
            labelToplamFiyat.text = String(newTotalFiyat)
        }
    }
    
    @IBAction func sepeteEkleAction(_ sender: Any) {
        if let y = yemek , let adet = labelYemekAdet.text{
            viewModel.kaydet(yemek_adi: y.yemek_adi!, yemek_fiyat: y.yemek_fiyat!, yemek_resim_adi: y.yemek_resim_adi!, yemek_siparis_adet: Int(adet)!, kullanici_adi: "damla")
        }
    }
}
