//
//  SepetHucre.swift
//  FoodsApp
//
//  Created by Damla Sahin on 21.10.2023.
//

import UIKit

class SepetHucre: UITableViewCell {
    
    @IBOutlet weak var labelSepetYemekAdi: UILabel!
    @IBOutlet weak var labelSepetBirimFiyat: UILabel!
    @IBOutlet weak var labelSepetToplamFiyat: UILabel!
    @IBOutlet weak var labelSepetAdet: UILabel!
    @IBOutlet weak var imageSepetYemek: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
