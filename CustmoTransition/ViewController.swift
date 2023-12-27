//
//  ViewController.swift
//  CustmoTransition
//
//  Created by George on 27.12.2023.
//

import UIKit
import SnapKit

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        transitionContext.containerView.addSubview(toViewController.view)
        
        if transitionContext.isAnimated {
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            
            let opacity: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = transitionDuration(using: transitionContext)
                animation.fromValue = 0.1
                animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                animation.toValue = 1.0
                return animation
            }()
           
            let move: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = transitionDuration(using: transitionContext)
          
                let w = UIScreen.main.bounds.width/2.0
                let h = UIScreen.main.bounds.height/2.0
                animation.fromValue = [-w, -h]
                animation.toValue = [w, h]
                
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                return animation
            }()
            
            let group: CAAnimationGroup = {
                let group = CAAnimationGroup()
                group.animations = [opacity, move]
                group.delegate = self
                group.duration = transitionDuration(using: transitionContext)
                return group
            }()
            
            self.transitionContext = transitionContext
            toViewController.view.layer.add(group, forKey: "rotateScaleGroup")
        }
        else {
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            transitionContext.completeTransition(true)
        }
    }
    
    private var transitionContext: UIViewControllerContextTransitioning? = nil
        
    func animationDidStop(_ animation: CAAnimation, finished isFinished: Bool) {
        transitionContext?.completeTransition(isFinished)
        transitionContext = nil
    }
}


class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        view.addSubview(btn)
        btn.snp.makeConstraints{ make in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(200)
            make.width.equalTo(100)
        }
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
    }
    
    @objc func pressed(){
        let destinationViewController = ViewControllerWithTransition()
        destinationViewController.modalPresentationStyle = .custom
        destinationViewController.transitioningDelegate = self
        present(destinationViewController, animated: true, completion: nil)
    }
    
    private let transition = FadeTransition()
        
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return transition
        }
}

