//
//  WHCurrentlyPlayingViewController.swift
//  Whoot
//
//  Created by Andre Green on 1/15/16.
//  Copyright © 2016 Andre Green. All rights reserved.
//

import UIKit

class WHCurrentlyPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var headerPullingLabel: UILabel!
    
    var alphaUser: WHUser?
    var user: WHUser
    let userManager: WHUserManager
    let picCache: WHPicCache
    let headerAlphaColor = UIColor(red:241, green:101, blue:102)
    let headerNonAlphaColor = UIColor(red:80, green:176, blue:227)
    var currentSongs = [
        "The Man Who Sold the World",
        "Five Years",
        "Modern Love",
        "Rebel, Rebel",
        "Ziggy Stardust",
        "Young Americans",
        "Heroes",
        "Moonage Daydream",
        "Changes",
        "Space Oddity"
    ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.userManager = appDelegate.userManager
        self.user = appDelegate.userManager.currentUser!
        self.alphaUser = appDelegate.userManager.alphaUser
        self.picCache = appDelegate.picCache
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.userManager = appDelegate.userManager
        self.user = appDelegate.userManager.currentUser!
        self.alphaUser = appDelegate.userManager.alphaUser
        self.picCache = appDelegate.picCache
        
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor(red: 37, green: 183, blue: 153)
        
        // setup the header view
        self.headerView.backgroundColor = self.userManager.isCurrentUserAlpha() ?
            self.headerAlphaColor : self.headerNonAlphaColor
        
        self.profilePicView.clipsToBounds = true
        self.profilePicView.layer.cornerRadius = 0.5*self.profilePicView.bounds.size.width
    
        if self.alphaUser != nil {
            self.picCache.getImage(self.alphaUser!.email, completion: { (pic) -> Void in
                if pic == nil {
                    let facebookHandler = WHFacebookHandler()
                    facebookHandler.getFacebookPic(self.alphaUser!, completion: { (image) -> Void in
                        if image == nil {
                            print("could not get image for: \(self.alphaUser!.email)")
                        } else {
                            self.picCache.setImage(self.alphaUser!.email, image: image!)
                            dispatch_async(dispatch_get_main_queue(),{
                                self.profilePicView.image = image
                                self.profilePicView.setNeedsDisplay()
                            })
                        }
                    })
                } else {
                    self.profilePicView.image = pic
                    self.profilePicView.setNeedsDisplay()
                }
            })
            
            self.headerNameLabel.text = self.alphaUser!.fullName()
            self.headerPullingLabel.text = self.makePullingText(self.user, isAlpha: self.userManager.isCurrentUserAlpha())
        }
        
        
        // testing music
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let musicHandler = appDelegate.musicHandler
        musicHandler.grabMusic()
        musicHandler.printMusic()
    }
    
    func makePullingText(user: WHUser, isAlpha: Bool) -> String {
        return "Pulling From: " + (isAlpha ? "You" : user.fullName())
    }
    
    // MARK: tableview methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentSongs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let labelColor = UIColor(red: 80, green: 176, blue: 227)
        let cell = self.tableView.dequeueReusableCellWithIdentifier(
            WHTableViewCellId.WHMainTableVeiwCell.rawValue,
            forIndexPath: indexPath
        ) as! WHMainTableVeiwCell
        cell.songLabel.textColor = labelColor
        cell.artistLabel.textColor = labelColor
        cell.voteCountLabel.textColor = UIColor(red: 149, green: 90, blue: 164)
        cell.voteCountLabel.textAlignment = NSTextAlignment.Center
        return cell
    }
    
    
}
