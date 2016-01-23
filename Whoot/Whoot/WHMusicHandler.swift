//
//  WHMusicHandler.swift
//  Whoot
//
//  Created by Andre Green on 1/16/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import Foundation
import MediaPlayer

class WHMusicHandler {
    var songs = [WHSong]()
    
    func grabMusic() {
        let mediaQuery = MPMediaQuery()
        if let queryResult = mediaQuery.items {
            for item in queryResult {
                if let title = item.title,
                    let album = item.albumTitle,
                    let artist = item.artist
                    where item.mediaType == MPMediaType.Music {
                        let song = WHSong(title: title, artist: artist, album: album)
                        self.songs.append(song)
                }
            }
        }
    }
    
    func organziedMusic() -> [String:[String]] {
        var music = [String:[String]]()
        for song in self.songs {
            if var songs = music[song.artist] {
                songs.append(song.title)
                music[song.artist] = songs
            } else {
                let newSongs = [song.title]
                music[song.artist] = newSongs
            }
        }
        
        return music
    }
    
    func printMusic() {
        let organizedMusic = self.organziedMusic()
        for (artist, songs) in organizedMusic {
            print("artist: \(artist) songs")
            for song in songs {
                print("\t\(song)")
            }
        }
    }
}
