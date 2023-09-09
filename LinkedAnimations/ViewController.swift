//
//  ViewController.swift
//  LinkedAnimations
//
//  Created by Kirill Milekhin on 07/09/2023.
//

import UIKit

final class ViewController: UIViewController {
    private let duration = 0.5
    private let scaleFactor = 1.5
    private let squareSide: CGFloat = 60
    private let margin: CGFloat = 10
    
    private lazy var squareView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var sliderView: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    private var animator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeConstaints()
    }
    
    private func makeConstaints() {
        view.addSubview(squareView)
        view.addSubview(sliderView)
        
        NSLayoutConstraint.activate([
            squareView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            squareView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            squareView.heightAnchor.constraint(equalToConstant: squareSide),
            squareView.widthAnchor.constraint(equalToConstant: squareSide),
            
            sliderView.leadingAnchor.constraint(equalTo: squareView.leadingAnchor),
            sliderView.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: 40),
            sliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            sliderView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func sliderTouchUp() {
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            self.transformSquare(with: 1)
            self.sliderView.setValue(1, animated: true)
        }
        animator?.startAnimation()
    }
    
    @objc private func sliderValueChanged() {
        transformSquare(with: sliderView.value)
    }
    
    private func transformSquare(with progress: Float) {
        let rotationAngle = (Float.pi / 2) * progress
        let rotation = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
        
        let progressedScaling = progress * (Float(scaleFactor) - 1) + 1
        let scaling = CGAffineTransform(scaleX: CGFloat(progressedScaling), y: CGFloat(progressedScaling))
        
        let centerX = view.bounds.width - (squareSide * CGFloat(scaleFactor)) - margin
        let progressedCenterX = margin + (squareSide / 2) + (centerX * CGFloat(progress))

        squareView.transform = rotation.concatenating(scaling)
        squareView.center.x = progressedCenterX
    }
}

