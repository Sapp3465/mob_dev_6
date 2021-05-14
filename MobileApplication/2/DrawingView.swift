//
//  DrawingView.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class DrawingView: UIView {
    
    private var zeroPoint: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    private var maxPoint: CGPoint {
        return CGPoint(x: bounds.maxX - 10, y: bounds.minY + 10)
    }
    
    private var minPoint: CGPoint {
        return CGPoint(x: bounds.minX + 10, y: bounds.maxY - 10)
    }
    
    private var shape: Drawing = .graphics
    
    override func layoutSubviews() {
        super.layoutSubviews()
        draw(bounds)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        draw(shape)
    }
    
    func draw(_ shape: Drawing) {
        clearDrawing()
        self.shape = shape
        switch shape {
        case .diagram:
            drawDiagram()
        case .graphics:
            drawGraphic()
        }
    }
    
    private func clearDrawing() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
}

extension DrawingView {
    
    private struct Diagram {
        
        static let colors: [(UIColor, CGFloat)] = [(.blue, 45/100),
                                                   (.purple, 5/100),
                                                   (.yellow, 25/100),
                                                   (.gray, 25/100)]
    }
    
    private func drawDiagram() {
        
        var startingAngle: CGFloat = -CGFloat.pi / 2
        
        Diagram.colors.forEach { (color, percent) in
            
            let path = UIBezierPath()
            let endingAngle = startingAngle + 2 * CGFloat.pi * percent
            
            path.addArc(withCenter: zeroPoint, radius: 70,
                        startAngle: startingAngle, endAngle: endingAngle,
                        clockwise: true)
            
            startingAngle = endingAngle
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.fillColor = .none
            shapeLayer.lineWidth = 35
            
            layer.addSublayer(shapeLayer)
        }
        
    }

}

extension DrawingView {
    
    private struct Graphic {
        
        static let scaleFactor: CGFloat = 50.0
        static let interval: ClosedRange = (-CGFloat.pi)...(.pi)
        static let f: (_ x: CGFloat) -> CGFloat = { cos($0) }

    }
    
    
    private func drawGraphic() {
        
        drawAxis()
        let path = UIBezierPath()
        
        let startX = Graphic.interval.lowerBound
        var point = CGPoint(x: zeroPoint.x + startX * Graphic.scaleFactor,
                            y: zeroPoint.y - Graphic.f(startX) * Graphic.scaleFactor)

        for x in stride(from: Graphic.interval.lowerBound, through: Graphic.interval.upperBound, by: 0.001) {

            path.move(to: point)

            let dx = x * Graphic.scaleFactor
            let dy = Graphic.f(x) * Graphic.scaleFactor
            
            point = CGPoint(x: zeroPoint.x + dx, y: zeroPoint.y - dy)
            path.addLine(to: point)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = .none
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
    }
    
    private func drawAxis() {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: zeroPoint.x, y: maxPoint.y))
        path.addLine(to: CGPoint(x: zeroPoint.x, y: minPoint.y))
        
        path.move(to: CGPoint(x: minPoint.x, y: zeroPoint.y))
        path.addLine(to: CGPoint(x: maxPoint.x, y: zeroPoint.y))
        
        path.move(to: CGPoint(x: zeroPoint.x + Graphic.scaleFactor, y: zeroPoint.y - 5))
        path.addLine(to: CGPoint(x: zeroPoint.x + Graphic.scaleFactor, y: zeroPoint.y + 5))
        
        path.move(to: CGPoint(x: zeroPoint.x - 5, y: zeroPoint.y - Graphic.scaleFactor))
        path.addLine(to: CGPoint(x: zeroPoint.x + 5, y: zeroPoint.y - Graphic.scaleFactor))
        
        
        for i in [-1, 1] {
            path.move(to: CGPoint(x: zeroPoint.x, y: maxPoint.y))
            path.addLine(to: CGPoint(x: zeroPoint.x + CGFloat(i) * 3, y: maxPoint.y + 5))
            
            path.move(to: CGPoint(x: maxPoint.x, y: zeroPoint.y))
            path.addLine(to: CGPoint(x: maxPoint.x - 5, y: zeroPoint.y + CGFloat(i) * 3))
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = .none
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
    }
    
}
