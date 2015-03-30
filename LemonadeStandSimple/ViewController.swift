//
//  ViewController.swift
//  LemonadeStandSimple
//
//  Created by Brian on 3/26/15.
//  Copyright (c) 2015 Melodity.com, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var lemons = 5
    var ice = 5
    var dollars = 15
    var day = 1
    var weather:Int = 1

    var lemonMix = 0
    var iceMix = 0
    
    var customers:[Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var customerCount: Int = 10

    @IBOutlet weak var iceInvLabel: UILabel!
    @IBOutlet weak var lemonInvLabel: UILabel!
    @IBOutlet weak var dollarInvLabel: UILabel!
    @IBOutlet weak var iceMixLabel: UILabel!
    @IBOutlet weak var lemonMixLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    
    @IBOutlet weak var weatherPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPressed(sender: UIButton) {
        lemons = 5
        ice = 5
        dollars = 15
        
        lemonMix = 0
        iceMix = 0
        
        day = 1
        weather = 1
        self.updateAll()
        
    }
    
    func updateAll () {
        iceInvLabel.text = "\(ice)"
        lemonInvLabel.text = "\(lemons)"
        dollarInvLabel.text = "\(dollars)"
        
        iceMixLabel.text = "\(iceMix)"
        lemonMixLabel.text = "\(lemonMix)"
        dayCountLabel.text = "Day \(day)"
    }

    @IBAction func icePurchPlus(sender: UIButton) {
        if dollars >= 1 {
            dollars--
            ice++
            self.updateAll()
        } else {
            showAlertWithText(header: "Not enough money", message: "Ice costs $1 each.")
        }
    }
    
    @IBAction func icePurchMinus(sender: UIButton) {
        switch ice {
        case 0:
            showAlertWithText(header: "Not enough ice.", message: "You have no ice to sell.")
        default:
            dollars++
            ice--
            self.updateAll()
        }
    }
    
    @IBAction func lemonPurchPlus(sender: UIButton) {
        if dollars >= 2 {
            dollars -= 2
            lemons++
            self.updateAll()
        } else {
            showAlertWithText(header: "Not enough money", message: "Lemons cost $2 each.")
        }
    }
    
    @IBAction func lemonPurchMinus(sender: UIButton) {
        switch lemons {
        case 0:
            showAlertWithText(header: "Not enough lemons.", message: "You have no lemons to sell.")
        default:
            dollars += 2
            lemons--
            self.updateAll()
        }
    }
    
    @IBAction func iceMixPlus(sender: UIButton) {
        if ice == 0 {
            showAlertWithText(header: "Too many ice", message: "You cannot mix more ice than you have in inventory.")
        } else {
            iceMix++
            ice--
            updateAll()
        }
    }

    @IBAction func iceMixMinus(sender: UIButton) {
        if iceMix == 0 {
            showAlertWithText(header: "No negatives", message: "For now, only use positive amounts of ice, please.")
        } else {
            iceMix--
            ice++
            updateAll()
        }
    }
    
    @IBAction func lemonMixPlus(sender: UIButton) {
        if lemons == 0 {
            showAlertWithText(header: "Too many lemons", message: "You cannot mix more lemons than you have in inventory.")
        } else {
            lemonMix++
            lemons--
            updateAll()
        }
    }
    
    @IBAction func lemonMixMinus(sender: UIButton) {
        if lemonMix == 0 {
            showAlertWithText(header: "No negatives", message: "For now, only use positive amounts of lemons, please.")
        } else {
            lemonMix--
            lemons++
            updateAll()
        }
    }
    
    @IBAction func startDayButton(sender: UIButton) {
        if lemonMix == 0 || iceMix == 0 {
            showAlertWithText(header: "Bad Mix", message: "You must use at least 1 lemon and 1 ice in the Mix.")
        } else {
            var lemonadeMix: Float = Float(lemonMix)/Float(iceMix)
            customerCount = Int(arc4random_uniform(UInt32(14)))
            switch weather {
            case 0:
                customerCount -= 1
                if customerCount <= 0 {
                    customerCount = 1
                }
            case 1:
                customerCount += 3
            default:
                customerCount += 10
            }
            lemonMix = 0
            iceMix = 0
            var buyers = 0
            for var i = 0; i < customerCount; i++ {
                customers[i] = Int(arc4random_uniform(UInt32(10)))
                switch customers[i] {
                case 0...3:
                    if lemonadeMix > 1.0 {
                        dollars++
                        buyers++
                    }
                case 4...5:
                    if lemonadeMix == 1.0 {
                        dollars++
                        buyers++
                    }
                default:
                    if lemonadeMix < 1.0 {
                        dollars++
                        buyers++
                    }
                }
            }
            day++
            
            if day == 31 {
                var total = dollars + ice + (2 * lemons) - 30
                showAlertWithText(header: "YOU MADE IT!", message: "After one month you've made a total profit of \(total) dollars.")
                lemons = 5
                ice = 5
                dollars = 15
                
                lemonMix = 0
                iceMix = 0
                
                day = 1
                weather = 1
                self.updateAll()
            } else {
                showAlertWithText(header: "Daily Report", message: "We had \(customerCount) customers come to the Lemonade Stand today.  We sold a total of \(buyers) cups of Lemonade.")
                updateWeather()
                updateAll()
            }
        }
    }
    
    func updateWeather () {
        weather = Int(arc4random_uniform(UInt32(3)))
        switch weather {
        case 0:
            weatherPic.image = UIImage(named: "Cold")
        case 1:
            weatherPic.image = UIImage(named: "Mild")
        default:
            weatherPic.image = UIImage(named: "Warm")
        }
    }
    
    func showAlertWithText (header : String = "Warning", message : String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    


}

