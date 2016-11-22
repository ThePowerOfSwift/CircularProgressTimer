//
//  CircularProgress.swift
//  MinimaList
//
//  Created by DaveTech on 2016/11/21.
//  Copyright © 2016年 DaveTech. All rights reserved.
//

import UIKit



class CircularProgress: UIView {

    
    private let shapeLayer = CAShapeLayer()
    private let interiorLayer = CAShapeLayer()
    
    private var label = UILabel()
    private var timer: Timer?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        shape()
    }

    private func shape(){
        
        interiorLayer.frame = bounds
        let path = UIBezierPath(arcCenter: {
            return CGPoint(x: interiorLayer.bounds.width/2, y: interiorLayer.bounds.size.height/2)
            }(), radius: bounds.size.width/2, startAngle: CGFloat(M_PI_2*3), endAngle: -CGFloat(M_PI_2), clockwise: false)
        interiorLayer.path = path.cgPath
        interiorLayer.fillColor = UIColor.clear.cgColor
        interiorLayer.lineWidth = 5
        interiorLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(interiorLayer)
        
        

        
        label = UILabel()
        label.backgroundColor = .clear
        label.sizeToFit()
        label.frame = bounds
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightLight)
        addSubview(label)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        addGestureRecognizer(panGesture)

    }
    func animation() {
        
        shapeLayer.frame = bounds
        let path = UIBezierPath(arcCenter: {
            return CGPoint(x: shapeLayer.bounds.width/2, y: shapeLayer.bounds.size.height/2)
            }(), radius: bounds.size.width/2, startAngle: CGFloat(M_PI_2*3), endAngle: -CGFloat(M_PI_2), clockwise: false)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.gray.cgColor
        layer.addSublayer(shapeLayer)
        
        let pathAnima = CABasicAnimation(keyPath: "strokeEnd")
        pathAnima.duration =  Double(currentInterval())
        pathAnima.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        pathAnima.fromValue = NSNumber(value: 0)
        pathAnima.toValue = NSNumber(value: 1)
        pathAnima.fillMode = kCAFillModeForwards
        pathAnima.isRemovedOnCompletion = false
        shapeLayer.add(pathAnima, forKey: "strokeEnd")
    }
    private func countdown() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshLable(sender:)), userInfo: nil, repeats: true)
        timer?.fire()
    }
    func refreshLable(sender: Timer) {
        
        if currentInterval() == 0 {
            sender.invalidate()
            for gesture in gestureRecognizers! {
                gesture.isEnabled = true
            }
            shapeLayer.removeFromSuperlayer()
        }else{
            label.text = convertTimeInterval(interval: Int(currentInterval()-1))
        }
    }
    private func currentInterval() -> Int{
        if label.text == nil {
            return 0
        }
        let text = label.text!
        let textArr = text.components(separatedBy: ":").map{Int.init($0)}
        if textArr.count == 3 {
            return 3600 * textArr[0]! + 60 * textArr[1]! + textArr[2]!
        }else{
            return 60 * textArr[0]! + textArr[1]!
        }
    }
    private func convertTimeInterval(interval: Int) -> String {
        if interval/3600 >= 1{
            let hour = interval/3600
            let minute = interval%3600/60
            let second = interval%60
            return String(format: "%02d:%02d:%02d", hour < 0 ? 0 : hour, minute < 0 ? 0 : minute, second < 0 ? 0 : second)
        }else{
            let minute = interval/60
            let second = interval%60
            return String(format: "%02d:%02d", minute < 0 ? 0 : minute, second < 0 ? 0 : second)
        }
    }
    var originalInterval = 0
    func pan(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            originalInterval = currentInterval()
        }
        let timeIterval = -sender.translation(in: self).y
        let interval = Int(timeIterval)*60 + originalInterval
        label.text = convertTimeInterval(interval: interval)
    }
    func start() {
        for gesture in gestureRecognizers! {
            gesture.isEnabled = false
        }
        animation()
        countdown()
    }
    func stop() {
        if timer != nil {
            timer?.invalidate()
        }
        for gesture in gestureRecognizers! {
            gesture.isEnabled = true
        }
        label.text = "00:00"
        shapeLayer.removeAnimation(forKey: "strokeEnd")
        shapeLayer.removeFromSuperlayer()
    }
    func setDuration(minute: TimeInterval){
        label.text = convertTimeInterval(interval: Int(minute))
    }
}
