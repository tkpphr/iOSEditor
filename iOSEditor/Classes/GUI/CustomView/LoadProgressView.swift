//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

public class LoadProgressView : UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    private func loadNib() {
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSEditor", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        let nib = UINib(nibName: "LoadProgressView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
