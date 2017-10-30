//
//  ViewController.swift
//  Currency
//
//  Created by Robert O'Connor on 18/10/2017.
//  Copyright © 2017 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK Model holders
    var currencyDict:Dictionary = [String:Currency]()
    var currencyArray = [Currency]()
    var baseCurrency:Currency = Currency.init(name:"EUR", rate:1, flag:"🇪🇺", symbol:"€")!
    var lastUpdatedDate:Date = Date()
    
    var convertValue:Double = 0
    
    //MARK Outlets
    //@IBOutlet weak var convertedLabel: UILabel!
    
    @IBOutlet weak var baseSymbol: UILabel!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var baseFlag: UILabel!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    @IBOutlet weak var gbpSymbolLabel: UILabel!
    @IBOutlet weak var gbpValueLabel: UILabel!
    @IBOutlet weak var gbpFlagLabel: UILabel!
    
    @IBOutlet weak var usdSymbolLabel: UILabel!
    @IBOutlet weak var usdValueLabel: UILabel!
    @IBOutlet weak var usdFlagLabel: UILabel!
    
    @IBOutlet weak var rusSymbolLabel: UILabel!
    @IBOutlet weak var rusValueLabel: UILabel!
    @IBOutlet weak var rusFlagLabel: UILabel!
    
    @IBOutlet weak var jpnSymbolLabel: UILabel!
    @IBOutlet weak var jpnValueLabel: UILabel!
    @IBOutlet weak var jpnFlagLabel: UILabel!
    
    @IBOutlet weak var polSymbolLabel: UILabel!
    @IBOutlet weak var polValueLabel: UILabel!
    @IBOutlet weak var polFlagLabel: UILabel!
    
    @IBOutlet weak var zarSymbolLabel: UILabel!
    @IBOutlet weak var zarValueLabel: UILabel!
    @IBOutlet weak var zarFlagLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // print("currencyDict has \(self.currencyDict.count) entries")
        
        // create currency dictionary
        self.createCurrencyDictionary()
        
        // get latest currency values
        getConversionTable()
        convertValue = 1
        
        // set up base currency screen items
        baseTextField.text = String(format: "%.02f", baseCurrency.rate)
        baseSymbol.text = baseCurrency.symbol
        baseFlag.text = baseCurrency.flag
        
        // set up last updated date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm a"
        lastUpdatedDateLabel.text = dateformatter.string(from: lastUpdatedDate)
        
        // display currency info
        self.displayCurrencyInfo()
        
        
        // setup view mover
        baseTextField.delegate = self
        
        self.convert(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCurrencyDictionary(){
        //let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
        //self.currencyDict[name] = c
        currencyDict["GBP"] = Currency(name:"GBP", rate:1, flag:"🇬🇧", symbol: "£")
        currencyDict["USD"] = Currency(name:"USD", rate:1, flag:"🇺🇸", symbol: "$")
        currencyDict["RUB"] = Currency(name:"RUB", rate:1, flag:"🇷🇺", symbol: "₽")
        currencyDict["JPY"] = Currency(name:"JPY", rate:1, flag:"🇯🇵", symbol: "¥")
        currencyDict["PLN"] = Currency(name:"PLN", rate:1, flag:"🇵🇱", symbol: "zł")
        currencyDict["ZAR"] = Currency(name:"ZAR", rate:1, flag:"🇿🇦", symbol: "R")
    }
    
    func displayCurrencyInfo() {
        // GBP
        if let c = currencyDict["GBP"]{
            gbpSymbolLabel.text = c.symbol
            gbpValueLabel.text = String(format: "%.02f", c.rate)
            gbpFlagLabel.text = c.flag
        }
        if let c = currencyDict["USD"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        if let c = currencyDict["RUB"]{
            rusSymbolLabel.text = c.symbol
            rusValueLabel.text = String(format: "%.02f", c.rate)
            rusFlagLabel.text = c.flag
        }
        if let c = currencyDict["JPY"]{
            jpnSymbolLabel.text = c.symbol
            jpnValueLabel.text = String(format: "%.02f", c.rate)
            jpnFlagLabel.text = c.flag
        }
        if let c = currencyDict["PLN"]{
            polSymbolLabel.text = c.symbol
            polValueLabel.text = String(format: "%.02f", c.rate)
            polFlagLabel.text = c.flag
        }
        if let c = currencyDict["ZAR"]{
            zarSymbolLabel.text = c.symbol
            zarValueLabel.text = String(format: "%.02f", c.rate)
            zarFlagLabel.text = c.flag
        }
    }
    
    
    func getConversionTable() {
        //var result = "<NOTHING>"
        
        let urlStr:String = "https://api.fixer.io/latest"
        
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response, data, error in
            
            indicator.stopAnimating()
            
            if error == nil{
                //print(response!)
                
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    //print(jsonDict)
                    
                    if let ratesData = jsonDict["rates"] as? NSDictionary {
                        //print(ratesData)
                        for rate in ratesData{
                            //print("#####")
                            let name = String(describing: rate.key)
                            let rate = (rate.value as? NSNumber)?.doubleValue
                            //var symbol:String
                            //var flag:String
                            
                            switch(name){
                            case "USD":
                                //symbol = "$"
                                //flag = "🇺🇸"
                                let c:Currency  = self.currencyDict["USD"]!
                                c.rate = rate!
                                self.currencyDict["USD"] = c
                            case "GBP":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["GBP"]!
                                c.rate = rate!
                                self.currencyDict["GBP"] = c
                            case "RUB":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["RUB"]!
                                c.rate = rate!
                                self.currencyDict["RUB"] = c
                            case "JPY":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["JPY"]!
                                c.rate = rate!
                                self.currencyDict["JPY"] = c
                            case "PLN":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["PLN"]!
                                c.rate = rate!
                                self.currencyDict["PLN"] = c
                            case "ZAR":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["ZAR"]!
                                c.rate = rate!
                                self.currencyDict["ZAR"] = c
                            default:
                                print("Ignoring currency: \(String(describing: rate))")
                            }
                            
                            /*
                             let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
                             self.currencyDict[name] = c
                             */
                        }
                        self.lastUpdatedDate = Date()
                    }
                }
                catch let error as NSError{
                    print(error)
                }
            }
            else{
                print("Error")
            }
            
        }
        
    }
    
    @IBAction func convert(_ sender: Any) {
        var resultGBP = 0.0
        var resultUSD = 0.0
        var resultRUB = 0.0
        var resultJPY = 0.0
        var resultPLN = 0.0
        var resultZAR = 0.0
        
        if let euro = Double(baseTextField.text!) {
            convertValue = euro
            if let gbp = self.currencyDict["GBP"] {
                resultGBP = convertValue * gbp.rate
            }
            if let usd = self.currencyDict["USD"] {
                resultUSD = convertValue * usd.rate
            }
            if let rub = self.currencyDict["RUB"] {
                resultRUB = convertValue * rub.rate
            }
            if let jpy = self.currencyDict["JPY"] {
                resultJPY = convertValue * jpy.rate
            }
            if let pln = self.currencyDict["PLN"] {
                resultPLN = convertValue * pln.rate
            }
            if let zar = self.currencyDict["ZAR"] {
                resultZAR = convertValue * zar.rate
            }
        }
        //GBP
        
        //convertedLabel.text = String(describing: resultGBP)
        
        gbpValueLabel.text = String(format: "%.02f", resultGBP)
        usdValueLabel.text = String(format: "%.02f", resultUSD)
        rusValueLabel.text = String(format: "%.02f", resultRUB)
        jpnValueLabel.text = String(format: "%.02f", resultJPY)
        polValueLabel.text = String(format: "%.02f", resultPLN)
        zarValueLabel.text = String(format: "%.02f", resultZAR)
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     
     }
     */
    
    
}

