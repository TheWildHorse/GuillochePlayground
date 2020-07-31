import Cocoa
import SpriteKit

public class GameScene: SKScene {
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
    }
    
    // The color varies from c1 to c2 and back to c1 as you step from 0 to totalSteps
    public func getColorGradientStep(color1: SKColor, color2: SKColor, step: Int, totalSteps: Int) -> SKColor {
        var color1Red: CGFloat = 0, color1Green: CGFloat = 0, color1Blue: CGFloat = 0
        color1.getRed(&color1Red, green: &color1Green, blue: &color1Blue, alpha: nil)
        var color2Red: CGFloat = 0, color2Green: CGFloat = 0, color2Blue: CGFloat = 0
        color2.getRed(&color2Red, green: &color2Green, blue: &color2Blue, alpha: nil)
        
        let redDelta = (color2Red - color1Red)
        let blueDelta = (color2Blue - color1Blue)
        let greenDelta = (color2Green - color1Green)
        
        let sineCorrection = CGFloat(sin(Double.pi * Double(step)/Double(totalSteps)))
        return SKColor(
            red: color1Red + redDelta * sineCorrection,
            green: color1Green + greenDelta * sineCorrection,
            blue: color1Blue + blueDelta * sineCorrection,
            alpha: 1.0
        )
    }
    
    public func getSuperformulaCurve(a: Double, b: Double, m1: Double, m2: Double, n1:Double, n2:Double, n3:Double, radius: Double, steps: Double) -> NSBezierPath {
        let curve: NSBezierPath = NSBezierPath()
        var current: Double = 0
        var r = pow(pow(abs((cos((m1*current)/4))/a),n2)+pow(abs((sin((m2*current)/4))/b),n3), -1/n1)*radius
        curve.move(to: CGPoint(x: r*cos(current), y: r*sin(current)))
        
        repeat {
            current = current + (2 * Double.pi / steps)
            r = pow(pow(abs((cos((m1*current)/4))/a),n2)+pow(abs((sin((m2*current)/4))/b),n3), -1/n1)*radius
            curve.line(to: CGPoint(x: r*cos(current), y: r*sin(current)))
        } while current <= Double.pi*2
        
        return curve
    }
    
    public func drawSpirograph(path1: NSBezierPath, path2: NSBezierPath, color1: SKColor, color2: SKColor, rotation: Double) {
        let points = path1.cgPath.getPathElementsPoints()
        var counter = 0;
        for element in points {
            let rotatorFunction: SKShapeNode = SKShapeNode(path: path2.cgPath)
            rotatorFunction.strokeColor = self.getColorGradientStep(color1: color1, color2: color2, step: counter, totalSteps: points.count)
            rotatorFunction.lineWidth = 1
            rotatorFunction.zRotation = CGFloat(rotation*Double(counter))
            rotatorFunction.position = CGPoint(x: element.x+350, y: element.y+350)
            self.addChild(rotatorFunction)
            counter = counter + 1
        }
    }
}

public extension NSBezierPath {
    
    var cgPath: CGPath {
        get {
            let path = CGMutablePath()
            let points = NSPointArray.allocate(capacity: 3)
            
            for i in 0 ..< self.elementCount {
                //for i in 0 ..< 30 {
                let type = self.element(at: i, associatedPoints: points)
                switch type {
                case .moveToBezierPathElement:
                    path.move(to: points[0])
                case .lineToBezierPathElement:
                    path.addLine(to: points[0])
                case .curveToBezierPathElement:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePathBezierPathElement:
                    path.closeSubpath()
                }
            }
            return path
        }
    }
    
}

public extension CGPath {
    
    func forEach(body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    
    func getPathElementsPoints() -> [CGPoint] {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            default: break
            }
        }
        return arrayPoints
    }
    
}
