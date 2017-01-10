//
//  QueueActions.swift
//  Volumio
//
//  Created by Federico Sintucci on 23/11/16.
//  Copyright © 2016 Federico Sintucci. All rights reserved.
//

import UIKit

protocol QueueActionsDelegate: class {
    func didRepeat()
    func didShuffle()
    func didConsume()
    func didClear()
}

class QueueActions: UIView {

    @IBOutlet weak var view: UIView!
    weak var delegate: QueueActionsDelegate?
    
    @IBOutlet weak var repeatState: UIButton!
    @IBOutlet weak var shuffleState: UIButton!
    @IBOutlet weak var consumeState: UIButton!

    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var shuffleLabel: UILabel!
    @IBOutlet weak var consumeLabel: UILabel!
    @IBOutlet weak var clearLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        UINib(nibName: "QueueActions", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        
        // L18N
        repeatLabel.text = NSLocalizedString("QUEUE_REPEAT",
            comment: "queue repeat label"
        )
        shuffleLabel.text = NSLocalizedString("QUEUE_SHUFFLE",
            comment: "queue shuffle label"
        )
        consumeLabel.text = NSLocalizedString("QUEUE_CONSUME",
            comment: "queue consume label"
        )
        clearLabel.text = NSLocalizedString("QUEUE_CLEAR",
            comment: "queue clear label"
        )
        
        repeatState.alpha = 0.3
        shuffleState.alpha = 0.3
        consumeState.alpha = 0.3
    }
    
    @IBAction func didPressRepeat(_ sender: Any) {
        delegate?.didRepeat()
    }
    
    @IBAction func didPressShuffle(_ sender: Any) {
        delegate?.didShuffle()
    }
    
    @IBAction func didPressConsume(_ sender: Any) {
        delegate?.didConsume()
    }
    
    @IBAction func didPressClear(_ sender: Any) {
        delegate?.didClear()
    }

    func updateStatus(track:TrackObject) {
        if let repetition = track.repetition {
            switch repetition {
            case 1: self.repeatState.alpha = 1
            default: self.repeatState.alpha = 0.3
            }
        }
        
        if let shuffle = track.shuffle {
            switch shuffle {
            case 1: self.shuffleState.alpha = 1
            default: self.shuffleState.alpha = 0.3
            }
        }
        
        if let consume = track.consume {
            switch consume {
            case 1: self.consumeState.alpha = 1
            default: self.consumeState.alpha = 0.3
            }
        }
    }
}
