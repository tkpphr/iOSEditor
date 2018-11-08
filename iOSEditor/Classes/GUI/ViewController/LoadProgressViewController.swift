//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

public class LoadProgressViewController : UIViewController {
    private var task:(() -> Bool)?
    private var finished:((_ isSucceed:Bool) -> Void)?
    private var isSucceed:Bool?
    
    public init(task:@escaping ()->Bool,finished:@escaping (_ isSucceed:Bool) -> Void){
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSEditor", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        super.init(nibName: "LoadProgressViewController", bundle: bundle)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.task = task
        self.finished = finished
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            [weak self] in
            self?.isSucceed = self?.task?()
            DispatchQueue.main.async {
                self?.dismiss(animated: false, completion: {
                    self?.finished?(self?.isSucceed ?? false)
                })
            }
        }
    }
}
