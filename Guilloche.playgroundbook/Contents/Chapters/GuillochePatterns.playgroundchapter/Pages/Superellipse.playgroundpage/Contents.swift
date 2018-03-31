/*:
 # Superellipse
 
 We will use a superellipse to draw our own cool looking guilloche pattern. Superellipse is a closed shape that can have interesting looking plots on a plane.
 
 **Click Run My Code**
 
 You probably already know one of its forms displayed on the right.
 *HINT: Your home screen is filled with them.*
 */

//#-hidden-code
import PlaygroundSupport
import SpriteKit

let canvasSize = 700

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
    }
    
    public func drawCurve(path: UIBezierPath, strokeColor: SKColor, fillColor: SKColor) {
        let rotatorFunction: SKShapeNode = SKShapeNode(path: path.cgPath)
        rotatorFunction.strokeColor = strokeColor
        rotatorFunction.fillColor = fillColor
        rotatorFunction.lineWidth = 2
        rotatorFunction.position = CGPoint(x: 350, y: 350)
        self.addChild(rotatorFunction)
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

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: canvasSize, height: canvasSize))
let scene:GameScene = GameScene(size: CGSize(width: canvasSize, height: canvasSize))
scene.scaleMode = SKSceneScaleMode.aspectFit
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code

//#-editable-code
let path = scene.getSuperformulaCurve(
    a: 1, b: 1,
    m1: 4, m2: 4,
    n1: 5, n2: 5, n3: 5,
    radius: 200, steps:250
)
scene.drawCurve(path: path, strokeColor: SKColor.blue, fillColor: SKColor.lightGray)
//#-end-editable-code

//: Try modifying its parameters to see how its plot changes.
