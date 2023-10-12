//
//  DotLineView.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/12.
//

import UIKit

@IBDesignable
class DotLineView: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 0
    @IBInspectable var dotColor: UIColor = .black
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.lineWidth = self.lineWidth
        path.lineCapStyle = .butt
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        let dashes = [path.lineWidth, path.lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        dotColor.setStroke()
        path.stroke()
    }
}
