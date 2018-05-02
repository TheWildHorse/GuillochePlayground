import Cocoa
import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 700, height: 700))
let scene: GameScene = GameScene(size: CGSize(width: 700, height: 700))
scene.scaleMode = SKSceneScaleMode.aspectFit
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

let path1 = scene.getSuperformulaCurve(
    a: 1, b: 1, m1: 8, m2: 8,
    n1: 20, n2: 20, n3: 12,
    radius: 120, steps: 400
)

let path2 = scene.getSuperformulaCurve(
    a: 1, b: 1, m1: 10, m2: 14,
    n1: 24, n2: 4, n3: 11,
    radius: 60, steps: 35
)

path1.cgPath.getPathElementsPoints()

scene.drawSpirograph(
    path1: path1, // The route
    path2: path2, // The path we are drawing
    color1: SKColor.red,
    color2: SKColor.orange,
    rotation: 0 // In Radians
)





