//
//  OrderNotification.swift
//  RestGraveton
//
//  Created by Daniel Zhagany Zamora on 2/23/23.
//

import UIKit
import AVFoundation

fileprivate let bannerHeight: CGFloat = 600

class OrderCustomView {
    
    var timer: Timer? = nil
    
    private var count:Int = 0
    
    let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        return backgroundView
    }()
    
    let exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 1050, y: 25, width: 50, height: 50))
        button.setImage(UIImage(systemName: "multiply")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50)).withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.size.width/2
        return button
    }()
    
    var panelView = CircleNotificationView()
    
    private var myTargetView: UIView?
    
    let getRootView = GetRootView()
    
    func getOrderCustomView(firstButton: String,secondButton:String,title: String,subTile:String, on viewController: UIViewController){
        
        if CameraManager.shared.isQuietOrLoud{
            timerFunction()
        }
        
        guard let targetView = viewController.view else {return}
        myTargetView = targetView
        
        panelView.acceptButton.setTitle(firstButton, for: .normal)
        panelView.rejectButton.setTitle(secondButton, for: .normal)
        panelView.titleLabel.text = title
        panelView.subTitleLabel.text = subTile
        
        backgroundView.frame = targetView.bounds
        
        let superView = getRootView.getRootView()
        
        superView.addSubview(backgroundView)
        
        backgroundView.addSubview(panelView)
        backgroundView.addSubview(exitButton)
        
        panelView.frame = CGRect(x: 0, y: 0, width: bannerHeight, height: bannerHeight)
        panelView.center = backgroundView.center
        
        UIView.animate(withDuration:0.25, animations: {
            
        },completion: { isDone in
            
            if isDone {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.panelView.frame = CGRect(x: 0, y: 0, width: bannerHeight, height: bannerHeight)
                    self.panelView.center = self.backgroundView.center
                    self.panelView.layer.cornerRadius = self.panelView.frame.size.width/2
                })
            }
        })
    }
    
    func removeOrderCustomView(){
        
        self.count = 0
        
        self.panelView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
        timer?.invalidate()
        timer = nil
    }
    
    func timerFunction(){
        
        if  timer != nil{return}
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            
            self.count += 1
            
            if self.count > 0 {
                self.playSystemSound(systemSound: 1008)
            }else{
                timer.invalidate()
            }
        }
        
        RunLoop.main.add(timer ?? Timer(), forMode: .common)
    }
    
    func playSystemSound(systemSound:SystemSoundID){
        
        AudioServicesPlayAlertSoundWithCompletion(systemSound){}
    }
}

