//
//  ChatGPTViewController.swift
//  Feature
//
//  Created by John Park on 2023/03/25.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import UIKit

open class HalfViewController: UIPresentationController {
    // MARK: – Properties
        private lazy var dimmingView: UIView = {
            let dimmingView = UIView()
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            dimmingView.alpha = 0.0
            
            let recognizer = UITapGestureRecognizer(target: self,
                                                    action: #selector(handleTap(recognizer:)))
            dimmingView.addGestureRecognizer(recognizer)
            
            return dimmingView
        }()
        
        public override var frameOfPresentedViewInContainerView: CGRect {
            var frame: CGRect = .zero
            frame.size = size(forChildContentContainer: presentedViewController,
                              withParentContainerSize: containerView!.bounds.size)
            
            frame.origin.y = containerView!.frame.height*(1.0/3.0)
            return frame
        }
        
        public override func presentationTransitionWillBegin() {
            guard let containerView = containerView else {
                return
            }
            
            containerView.insertSubview(dimmingView, at: 0)
            
            NSLayoutConstraint.activate([
                dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
                dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            guard let coordinator = presentedViewController.transitionCoordinator else {
                dimmingView.alpha = 1.0
                return
            }
            
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
            })
        }
        
        public override func dismissalTransitionWillBegin() {
            guard let coordinator = presentedViewController.transitionCoordinator else {
                dimmingView.alpha = 0.0
                return
            }
            
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
            })
        }
        
        public override func containerViewWillLayoutSubviews() {
            presentedView?.frame = frameOfPresentedViewInContainerView
        }
        
        public override func size(forChildContentContainer container: UIContentContainer,
                           withParentContainerSize parentSize: CGSize) -> CGSize {
            return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
        }
    
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
