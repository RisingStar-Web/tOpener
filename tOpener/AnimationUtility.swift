//
//  AnimationUtility.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 07/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import UIKit

class AnimationUtility: UIViewController {

   
        static func animateBubbleTrnsitionView( selfView: UIView, point : CGPoint) {
            //let button = CGRect.init(x: 30, y: selfView.frame.size.height - 15, width: 45, height: 45)
            let button = CGRect.init(x: point.x, y: point.y, width: 0, height: 0)
            
            let circleMaskPathInitial = UIBezierPath(ovalIn: CGRect.init(x: point.x, y: point.y, width: 1, height: 1))
            let extremePoint = CGPoint(x: point.x, y: 15 - selfView.frame.size.height - 200)
            let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
            let circleMaskPathFinal = UIBezierPath(ovalIn: (button.insetBy(dx: -radius, dy: -radius)))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = circleMaskPathFinal.cgPath
            selfView.layer.mask = maskLayer
            
            let maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
            maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
            maskLayerAnimation.duration =  0.5
            maskLayer.add(maskLayerAnimation, forKey: "path")
        }
}
