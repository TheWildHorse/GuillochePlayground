/*:
 # Spirograph
 
 One of the methods to draw a Guilloché pattern is using a spirograph. Spirograph is a technique of drawing a path of a function along a path of a different function.
 
 Press **Run My Code** to see an animated example.
 */

//#-hidden-code
import UIKit
import PlaygroundSupport

class SpirographController : UIViewController {
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    public func drawCurve(path: UIBezierPath, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.position = CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.width/4)
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
    }
    
    public func drawCurveAnimatedAlongPath(curve: UIBezierPath, path: UIBezierPath, color: UIColor) {
        var translation = CGAffineTransform(translationX: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.width/4)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath.copy(using: &translation)
        animation.calculationMode = kCAAnimationPaced
        animation.repeatCount = HUGE
        animation.duration = 10
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = 5
        rotateAnimation.repeatCount = HUGE
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = curve.cgPath
        shapeLayer.add(animation, forKey: nil)
        shapeLayer.add(rotateAnimation, forKey: nil)
        
        view.layer.addSublayer(shapeLayer)
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
let scene = SpirographController()
PlaygroundPage.current.liveView = scene
//#-end-hidden-code
//#-editable-code
let path1 = scene.getSuperformulaCurve(
    a: 1, b: 1, m1: 8, m2: 8,
    n1: 8, n2: 8, n3: 8,
    radius: 100, steps: 350
)
let path2 = scene.getSuperformulaCurve(
    a: 1, b: 1, m1: 5, m2: 5,
    n1: 8, n2: 8, n3: 8,
    radius: 60, steps: 350
)
scene.drawCurve(path: path1, color: UIColor.lightGray)
scene.drawCurveAnimatedAlongPath(curve: path2, path: path1, color: UIColor.orange)
//#-end-editable-code

