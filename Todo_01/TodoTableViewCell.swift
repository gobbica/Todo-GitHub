//
//  TodoTableViewCell.swift
//  Todo_01
//
//  Created by Candido Gobbi on 23.04.17.
//  Copyright © 2017 Candido Gobbi. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeTodo_Label: UILabel!
    @IBOutlet weak var dataScadenza_Label: UILabel!
    @IBOutlet weak var immagine_ImageView: UIImageView!
    @IBOutlet weak var descrizioneTodo_Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
