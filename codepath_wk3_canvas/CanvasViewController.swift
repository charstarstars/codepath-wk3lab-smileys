//
//  CanvasViewController.swift
//  codepath_wk3_canvas
//
//  Created by Ariel Liu on 2/22/16.
//  Copyright © 2016 Ariel Liu. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    var newlyCreatedFaceOriginalTransform: CGAffineTransform!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPinchCanvasFace(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        
        newlyCreatedFace = sender.view as! UIImageView
        
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedFaceOriginalTransform = newlyCreatedFace.transform
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.transform = CGAffineTransformScale(newlyCreatedFaceOriginalTransform, scale, scale)
        }
    }
    
    func didDragCanvasFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            newlyCreatedFaceOriginalTransform = newlyCreatedFace.transform
            
            UIView.animateWithDuration(
                0.2,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.newlyCreatedFace.transform = CGAffineTransformScale(self.newlyCreatedFaceOriginalTransform, 1.5, 1.5)
                },
                completion: {
                    (Bool) -> Void in
                }
            )
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(
                0.2,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.newlyCreatedFace.transform = self.newlyCreatedFaceOriginalTransform
                },
                completion: {
                    (Bool) -> Void in
                }
            )
            
        }
    }
    
    @IBAction func didDragFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            let imageView = sender.view as! UIImageView
            
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.userInteractionEnabled = true
            
            view.addSubview(newlyCreatedFace)
            
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animateWithDuration(
                0.2,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.5, 1.5)
                },
                completion: {
                    (Bool) -> Void in
                }
            )
            
            let panGesture = UIPanGestureRecognizer(target: self, action: "didDragCanvasFace:")
            newlyCreatedFace.addGestureRecognizer(panGesture)
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: "didPinchCanvasFace:")
            newlyCreatedFace.addGestureRecognizer(pinchGesture)
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)

            
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(
                0.2,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.newlyCreatedFace.transform = CGAffineTransformIdentity
                },
                completion: {
                    (Bool) -> Void in
                }
            )
            
        }
    }
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(
                0.4,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    
                    if velocity.y > 0 {
                        // tray is moving up
                        self.trayView.center = self.trayDown
                    } else {
                        self.trayView.center = self.trayUp
                    }
                },
                completion: {
                    (Bool) -> Void in
                })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
