//
//  BookClubTableViewCell.swift
//  BookClub
//
//  Created by Cynthia Whitlatch on 6/23/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class BookClubTableViewCell: UITableViewCell {

    @IBOutlet weak var clubBookRating: UILabel!
    @IBOutlet weak var clubBookReadTitle: UILabel!
    @IBOutlet weak var clubBookReadImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
