//
//  WHSong.swift
//  Whoot
//
//  Created by Andre Green on 1/16/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation

class WHSong {
    var title: String
    var artist: String
    var album: String
    
    init(title: String, artist: String, album: String) {
        self.title = title
        self.artist = artist
        self.album = album
    }
    
    var description:String {
        return "song: \(self.title), artist: \(self.artist), album: \(self.album)"
    }
}
