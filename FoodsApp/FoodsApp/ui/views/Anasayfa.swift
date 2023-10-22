//
//  ViewController.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import UIKit
import RxSwift

class Anasayfa: UIViewController {
    @IBOutlet weak var yemeklerTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var yemeklerListesi = [Yemekler]()
    
    var viewModel = AnasayfaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yemeklerTableView.delegate = self
        yemeklerTableView.dataSource = self
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemeklerListesi = liste
            DispatchQueue.main.async {
                self.yemeklerTableView.reloadData()
            }
        })
        
        
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
        viewModel.yemekleriYukle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let yemek = sender as? Yemekler {
                let gidilecekVC = segue.destination as! Sepet
                gidilecekVC.yemek = yemek
            }
        } else if segue.identifier == "goToDetay", let gidilecekVC = segue.destination as? YemekKayit, let yemekToTransfer = sender as? Yemekler {
            gidilecekVC.yemek = yemekToTransfer
        }
    }
}


extension Anasayfa : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yemeklerListesi.count//3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: "yemeklerHucre") as! YemeklerHucre

        let yemek = yemeklerListesi[indexPath.row]
        hucre.labelYemekAd.text = yemek.yemek_adi ?? "N/A"
        if let imageName = yemek.yemek_resim_adi, let imageURL = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)") {
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        hucre.imageYemek.image = image
                    }
                }
            }.resume()
        } else {
            hucre.imageYemek.image = UIImage(named: "defaultImage")
        }

        if let fiyat = yemek.yemek_fiyat {
            hucre.labelYemekFiyat.text = String(fiyat)
        } else {
            hucre.labelYemekFiyat.text = "N/A"
        }
        hucre.layer.cornerRadius = 5
        hucre.layer.borderColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0).cgColor
        hucre.layer.borderWidth = 1
        return hucre
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let yemek = yemeklerListesi[indexPath.row]
        print("yemek \(yemek.yemek_adi)")
        performSegue(withIdentifier: "goToDetay", sender: yemek)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){ contextualAction,view,bool in
            let yemek = self.yemeklerListesi[indexPath.row]
            
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(yemek.yemek_adi!) silinsi mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive){ action in
                self.viewModel.sil(sepet_yemek_id: Int(yemek.sepet_yemek_id!)!, kullanici_adi: yemek.yemek_kullanici_adi!)
            }
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }
}
