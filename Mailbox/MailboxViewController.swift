//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Jason Cashdollar on 11/3/15.
//  Copyright © 2015 Jason Cashdollar. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var helpView: UIImageView!
    @IBOutlet weak var searchView: UIImageView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    
    var panStartLocation: CGPoint!

    let green: UIColor! = UIColor(red: 0.36, green: 0.86, blue: 0.36, alpha: 1)
    let red: UIColor! = UIColor(red: 0.95, green: 0.33, blue: 0, alpha: 1)
    let yellow: UIColor! = UIColor(red: 1, green: 0.83, blue: 0.0, alpha: 1)
    let brown: UIColor! = UIColor(red: 0.85, green: 0.65, blue: 0.44, alpha: 1)
    let grey: UIColor! = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize.height = feedView.frame.height + messageView.frame.height + helpView.frame.height + searchView.frame.height

        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        messageView.addGestureRecognizer(panGestureRecognizer)
        messageContainer.backgroundColor = UIColor.grayColor()
        
        rescheduleView.alpha = 0
        listView.alpha = 0
        archiveIcon.alpha = 0.5
        deleteIcon.alpha = 0
        laterIcon.alpha = 0.5
        listIcon.alpha = 0
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translationInView(view)
//        let velocity = panGestureRecognizer.velocityInView(view)
        
        messageView.frame.origin.x = translation.x
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            if translation.x > 60 && translation.x < 200{
 
                messageContainer.backgroundColor = green
                deleteIcon.alpha = 0
                archiveIcon.alpha = 1
                archiveIcon.frame.origin.x = messageView.frame.origin.x - 40
                
                
            } else if translation.x > 200 {

                messageContainer.backgroundColor = red
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
                deleteIcon.frame.origin.x = messageView.frame.origin.x - 40
                
            } else if translation.x < -60 && translation.x > -200 {
                
                messageContainer.backgroundColor = yellow
                listIcon.alpha = 0
                laterIcon.alpha = 1
                laterIcon.frame.origin.x = messageView.frame.origin.x + messageView.frame.width + 20

                
            } else if translation.x < -200 {
                
                messageContainer.backgroundColor = brown
                laterIcon.alpha = 0
                listIcon.alpha = 1
                listIcon.frame.origin.x = messageView.frame.origin.x + messageView.frame.width + 20
            } else if translation.x > -60 && translation.x < 60 {
                archiveIcon.alpha = 0.5
                laterIcon.alpha = 0.5
                messageContainer.backgroundColor = grey
            }
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            // icons should disappear after release
            archiveIcon.alpha = 0
            deleteIcon.alpha = 0
            laterIcon.alpha = 0
            listIcon.alpha = 0
            
            if messageView.frame.origin.x > 60 {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = self.view.frame.width
                })
                
            } else if messageView.frame.origin.x < -60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x -= self.view.frame.width
                })
            } else if messageView.frame.origin.x < 60 && messageView.frame.origin.x > -60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                })
            }
            
            // specify how to end animation. whether new view should show or email should hide
            if messageContainer.backgroundColor == green || messageContainer.backgroundColor == red {
                self.hideEmail()
            } else if messageContainer.backgroundColor == yellow {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.rescheduleView.alpha = 1
                })
            } else if messageContainer.backgroundColor == brown {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.listView.alpha = 1
                })
            }
        }
    }
    
    func hideEmail() {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.feedView.frame.origin.y -= 90
        }
    }
    
    @IBAction func didTapListView(sender: AnyObject) {
        listView.hidden = true
        hideEmail()
    }

    @IBAction func didTapRescheduleView(sender: AnyObject) {
        rescheduleView.hidden = true
        hideEmail()
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        // stuff
        let contentTranslation = sender.translationInView(view)
        let menuOpen: CGFloat! = 280
        let menuClosed: CGFloat! = 0
        
        contentView.frame.origin.x = contentTranslation.x
        
        if sender.state == UIGestureRecognizerState.Ended {
            if contentTranslation.x > 100 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.contentView.frame.origin.x = menuOpen
                })
                
            } else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.contentView.frame.origin.x = menuClosed
                })
            }
        }
    }
}
