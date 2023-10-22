//
//  YemeklerHucre.swift
//  FoodsApp
//
//  Created by Damla on 21.09.2023.
//

import UIKit

class YemeklerHucre: UITableViewCell {
    
    @IBOutlet weak var labelYemekAd: UILabel!
    @IBOutlet weak var labelYemekFiyat: UILabel!
    @IBOutlet weak var imageYemek: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
