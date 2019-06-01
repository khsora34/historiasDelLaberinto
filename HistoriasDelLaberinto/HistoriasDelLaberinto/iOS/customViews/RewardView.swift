//
//  RewardView.swift
//  HistoriasDelLaberinto
//
//  Created by SYS_CIBER_ADMIN on 01/06/2019.
//  Copyright © 2019 SetonciOS. All rights reserved.
//

import UIKit

class RewardView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    var item: String? {
        get {
            return itemLabel.text
        }
        set {
            itemLabel.text = newValue
            itemLabel.isHidden = false
        }
    }
    
    var quantity: String? {
        get {
            return quantityLabel.text
        }
        set {
            quantityLabel.text = newValue
            quantityLabel.isHidden = false
        }
    }
    
    var isLast: Bool? {
        didSet {
            separator.isHidden = isLast ?? false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "RewardView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        itemLabel.isHidden = true
        quantityLabel.isHidden = true
        imageView.isHidden = true
        contentView.alpha = 0.95
    }
}
