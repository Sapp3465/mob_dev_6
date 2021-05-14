//
//  DrawingViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var drawingView: DrawingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        draw()
    }

    func draw() {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            drawingView.draw(Drawing.graphics)
        case 1:
            drawingView.draw(Drawing.diagram)
        default:
            return
        }
    }
}
