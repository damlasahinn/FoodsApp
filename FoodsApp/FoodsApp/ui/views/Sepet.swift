//
//  Sepet.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import UIKit
import RxSwift

class Sepet: UIViewController {
    
    @IBOutlet weak var sepetTableView: UITableView!
    var yemek:Yemekler?
    
    @IBOutlet weak var labelSepetTotal: UILabel!
    var yemeklerListesi = [SepetYemekler]()
    var viewModel = SepetViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sepetTableView.delegate = self
        sepetTableView.dataSource = self
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemeklerListesi = liste
            DispatchQueue.main.async {
                self.sepetTableView.reloadData()
                self.calculateTotal(sepet: self.yemeklerListesi)
            }
        }).disposed(by: disposeBag)
        
        if let tabItems = tabBarController?.tabBar.items {
            let anasayfaItem = tabItems[0]
            let sepetItem = tabItems[1]
        }
        
        let apperance = UITabBarAppearance()
        apperance.backgroundColor = UIColor.black
        
        renkDegistir(itemAppearance: apperance.stackedLayoutAppearance)
        renkDegistir(itemAppearance: apperance.inlineLayoutAppearance)
        renkDegistir(itemAppearance: apperance.compactInlineLayoutAppearance)
        
        tabBarController?.tabBar.standardAppearance = apperance
        tabBarController?.tabBar.scrollEdgeAppearance = apperance
    }
    
    func renkDegistir(itemAppearance:UITabBarItemAppearance){
        itemAppearance.selected.iconColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        ]
        
        itemAppearance.normal.iconColor = UIColor.white
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white
        ]
        itemAppearance.normal.badgeBackgroundColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.sepetiYukle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func sepetiOnaylaAction(_ sender: Any) {
        let emptyAlert = UIAlertController(title: "Sepet Onaylandı.", message: "Siparişiniz alınmıştır.", preferredStyle: .alert)
        let tamamAction = UIAlertAction(title: "Tamam", style: .default) { action in
            self.viewModel.sepetiTemizle(kullanici_adi: "damla")
            self.yemeklerListesi.removeAll()
            self.viewModel.sepetiYukle()
            self.sepetTableView.reloadData()
            self.calculateTotal(sepet: self.yemeklerListesi)
            self.performSegue(withIdentifier: "toYemekler", sender: nil)
        }
        emptyAlert.addAction(tamamAction)
        self.present(emptyAlert, animated: true)
        
    }
    
    @IBAction func sepetiSilAction(_ sender: Any) {
        viewModel.sepetiTemizle(kullanici_adi: "damla")
        self.yemeklerListesi.removeAll()
        viewModel.sepetiYukle()
        self.sepetTableView.reloadData()
        self.calculateTotal(sepet: self.yemeklerListesi)
        let emptyAlert = UIAlertController(title: "Sepet Boş", message: "Sepetinizde hiç ürün kalmadı.", preferredStyle: .alert)
        let tamamAction = UIAlertAction(title: "Tamam", style: .default) { action in
            self.performSegue(withIdentifier: "toYemekler", sender: nil)
        }
        emptyAlert.addAction(tamamAction)
        self.present(emptyAlert, animated: true)
    }
    
    func calculateTotal(sepet: [SepetYemekler]) {
        var toplamFiyat = 0
                
        for yemek in sepet {
            if let fiyat = Int(yemek.yemek_fiyat ?? "0"), let adet = Int(yemek.yemek_siparis_adet ?? "0") {
                toplamFiyat += fiyat * adet
            }
        }
        
        labelSepetTotal.text = String(toplamFiyat)
    }
}

extension Sepet : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return yemeklerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: "sepetHucre") as! SepetHucre
        
        let yemek = yemeklerListesi[indexPath.row]
        hucre.labelSepetYemekAdi.text = yemek.yemek_adi ?? "N/A"
        
        if let imageName = yemek.yemek_resim_adi, let imageURL = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)") {
            URLSession.shared.dataTask(with: imageURL) { data, _,error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        hucre.imageSepetYemek.image = image
                    }
                }
            }.resume()
        } else {
            hucre.imageSepetYemek.image = UIImage(named: "defaultImage")
        }
        
        if let fiyat = yemek.yemek_fiyat {
            hucre.labelSepetBirimFiyat.text = String(fiyat)
        } else {
            hucre.labelSepetBirimFiyat.text = "N/A"
        }
        if let adet = yemek.yemek_siparis_adet {
            hucre.labelSepetAdet.text = String(adet)
        } else {
            hucre.labelSepetAdet.text = "N/A"
        }
        
        if let fiyatString = yemek.yemek_fiyat, let adetString = yemek.yemek_siparis_adet, let fiyat = Int(fiyatString), let adet = Int(adetString) {
            let totalFiyat = fiyat * adet
            hucre.labelSepetToplamFiyat.text = String(totalFiyat)
        } else {
            hucre.labelSepetToplamFiyat.text = "N/A"
        }
        
        hucre.layer.cornerRadius = 5
        hucre.layer.borderColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0).cgColor
        hucre.layer.borderWidth = 1

        return hucre
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){ [weak self] contextualAction, view, bool in
            guard let self = self else { return }
            let yemek = self.yemeklerListesi[indexPath.row]
            
            let alert = UIAlertController(title: "Sepetten sil", message: "\(yemek.yemek_adi ?? "Bu yemek") silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive){ action in
                self.viewModel.sil(sepet_yemek_id: Int(yemek.sepet_yemek_id!)!, kullanici_adi: "damla")
                self.yemeklerListesi.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.calculateTotal(sepet: self.yemeklerListesi)
                
                if self.yemeklerListesi.isEmpty {
                    let emptyAlert = UIAlertController(title: "Sepet Boş", message: "Sepetinizde hiç ürün kalmadı.", preferredStyle: .alert)
                    let tamamAction = UIAlertAction(title: "Tamam", style: .default) { action in
                        self.yemeklerListesi.removeAll()
                        self.viewModel.sepetiYukle()
                        self.sepetTableView.reloadData()
                        self.calculateTotal(sepet: self.yemeklerListesi)
                        self.performSegue(withIdentifier: "toYemekler", sender: nil)
                    }
                    emptyAlert.addAction(tamamAction)
                    self.present(emptyAlert, animated: true)
                }
            }
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }

    
}
