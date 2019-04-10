//
//  ViewController.swift
//  AbstractFactoryExample
//
//  Created by Aleksandr Bydaiev on 4/5/19.
//  Copyright © 2019 ab.name. All rights reserved.
//

import UIKit

//==========================================================================

protocol UIFactory {
    
//    static func createUI<T:UIButton> () -> (T) where T:Decoratable
    static func createUI<T:UIView> () -> (T) where T:Decoratable
}

protocol Decoratable {
    
   func decorate()
}



extension Decoratable where Self: UIView {
    
    func decorate() {
        self.decorateUIView()
    }
    
    func decorateUIView() {
        
        self.backgroundColor = .orange
        //self.setTitle("WhiteScheme", for: .normal)
        //self.setTitleColor(.black, for: .normal)
        
    }
    
}


extension Decoratable where Self: UIButton {
    
    func decorate() {
        self.decorateUIButton()
    }
    
    func decorateUIButton() {
        
    }
    
}

//==========================================================================


class WhiteSchemeFactory: UIFactory {
    
    static func createUI <T:UIView> () -> (T) where T:Decoratable {
    //static func createUI<T:UIButton> () -> (T) where T:Decoratable {
        
        let button = WhiteSchemeButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        return button as! (T)
    }
}

class BlackSchemeFactory: UIFactory {
    
    static func createUI<T:UIView> () -> (T) where T:Decoratable {
    //static func createUI<T:UIButton> () -> (T) where T:Decoratable {
        
        let button = BlackSchemeButton(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
        
        return button as! (T)
    }
}

class GreySchemeFactory: UIView, UIFactory {
    
    static func createUI<T:UIView> () -> (T) where T:Decoratable {
        //static func createUI<T:UIButton> () -> (T) where T:Decoratable {
        
        let view = BaseSchemeButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        return view as! (T)
    }
}

//class BaseSchemeButton : UIButton , Decoratable {
//
//    func decorate() {
//
//        assert(false, "Should be Overrided in SubClasses")
//    }
//}

class BaseSchemeButton : UIView , Decoratable {
    
    func decorate() {
        
        self.backgroundColor = .orange
        //assert(false, "Should be Overrided in SubClasses")
    }
}


class WhiteSchemeButton : BaseSchemeButton {
    
    override func decorate() {
        
        self.backgroundColor = .white
        //self.setTitle("WhiteScheme", for: .normal)
        //self.setTitleColor(.black, for: .normal)
        
        //Render a button in a Windows style
    }
}

class BlackSchemeButton : BaseSchemeButton {
    
    override func decorate() {
        
        self.backgroundColor = .black
        //self.setTitle("BlackScheme", for: .normal)
        //self.setTitleColor(.white, for: .normal)
        
        //Render a button in a Mac OS X style
    }
}

enum Appearance: Int {
    case white = 0
    case black
    case grey
    //case appearanceCount
}

//enum Appearance: String {
//    case white,black,appearanceCount
//}


//extension DrawButton where Self: UIButton {}


class DemoController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView : UIPickerView!
    
    var button = BaseSchemeButton()
    
    var appearanceScheme: Appearance! = .white
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.appearanceScheme = .white;
        
        self.configAppearance()
    }
    
    
    private func configAppearance () {
        
        self.button.removeFromSuperview()
        
        switch (self.appearanceScheme) {
            
        case .white?:
            
            self.button = WhiteSchemeFactory.createUI()
            break;
            
        case .black?:
            
            self.button = BlackSchemeFactory.createUI()
            break;
            
        case .grey?:
            
            self.button = GreySchemeFactory.createUI()
            break;
            
        default:
            break;
        }
        

        self.button.decorate()
        
        self.button.center = self.view.center
        
        self.view.addSubview(self.button)
        
    }
    
    /// MARK : UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        self.appearanceScheme = Appearance.init(rawValue: row)
        
        switch self.appearanceScheme {
        case .white?:
            self.appearanceScheme = .black
        case .black?:
            self.appearanceScheme = .white
        default: break
            
        }
        
        self.configAppearance()
        
    }
    
    
    /// MARK : UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        let ind = Appearance.init(rawValue: row)
        
        var str = ""
        
        switch ind {
        case .white?:
            str = "white"
            break
        case .black?:
            str = "black"
            break
        case .grey?:
            str = "grey"
            break
        default:
            break
        }
        
        
        return str
    }

}
