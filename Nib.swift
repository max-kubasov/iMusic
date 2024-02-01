//
//  Nib.swift
//  iMusic
//
//  Created by Max on 01.02.2024.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil)![0] as! T
    }
}
