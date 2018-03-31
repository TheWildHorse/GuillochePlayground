/*:
 # Guilloché Pattern
 
 Finally, lets create our own Guilloché pattern. Press **Run My Code** to see my special pattern and try to edit the code at the bottom to create your own.
 */

//#-hidden-code
import PlaygroundSupport
import SpriteKit


// Hacks because playground hates applyWithBlock even on iOS 11
extension CGPath {
    
    func forEach( body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        print(MemoryLayout.size(ofValue: body))
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

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
    }
    
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
    
    public func drawSpirograph(path1: UIBezierPath, path2: UIBezierPath, color1: SKColor, color2: SKColor, rotation: Double) {
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
    
    public func getSuperformulaCurve(a: Double, b: Double, m1: Double, m2: Double, n1:Double, n2:Double, n3:Double, radius: Double, steps: Double) -> UIBezierPath {
        let curve: UIBezierPath = UIBezierPath()
        var current: Double = 0
        var r = pow(pow(abs((cos((m1*current)/4))/a),n2)+pow(abs((sin((m2*current)/4))/b),n3), -1/n1)*radius
        curve.move(to: CGPoint(x: r*cos(current), y: r*sin(current)))
        repeat {
            current = current + (2*Double.pi/steps)
            r = pow(pow(abs((cos((m1*current)/4))/a),n2)+pow(abs((sin((m2*current)/4))/b),n3), -1/n1)*radius
            curve.addLine(to: CGPoint(x: r*cos(current), y: r*sin(current)))
        }
            while current <= Double.pi*2
        
        return curve
    }
}



let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 700, height: 700))
let scene:GameScene = GameScene(size: CGSize(width: 700, height: 700))
scene.scaleMode = SKSceneScaleMode.aspectFit
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//#-end-hidden-code

//#-editable-code
let path1 = scene.getSuperformulaCurve(
    a: 1, b: 1, m1: 8, m2: 8,
    n1: 8, n2: 8, n3: 8,
    radius: 160, steps: 350
)
let path2 = scene.getSuperformulaCurve(
    a: 1, b: 1, m1: 7, m2: 7,
    n1: 12, n2: 4, n3: 12,
    radius: 80, steps: 350
)
scene.drawSpirograph(
    path1: path1, // The route
    path2: path2, // The path we are drawing
    color1: SKColor.green,
    color2: SKColor.orange,
    rotation: 0 // In Radians
)
//#-end-editable-code


