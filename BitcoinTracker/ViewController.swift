//
//  ViewController.swift
//  BitcoinTracker
//
//  Created by Abdelrahman Esmail on 11/07/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var ethLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var audLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    let url = "https://api.coingecko.com/api/v3/exchange_rates"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        
        func fetchData()
        {
            let url = URL(string: url)
            let defaultSession = URLSession(configuration: .default)
            let dataTask = defaultSession.dataTask(with: url!){
                (data:Data?, response: URLResponse?,error: Error?) in
                if(error != nil)
                {
                    print(error!)
                    return
                }
                do
                {
                    let json = try JSONDecoder().decode(Rates.self, from: data!)
                    self.setPrices(currency: json.rates)
                    
                }
                catch
                {
                    print(error)
                    return
                }
                
                
            }
            dataTask.resume()
        }
        
    }
    struct Rates: Codable
    {
        let rates : Currency
    }
    
    struct Currency: Codable
    {
        let btc: Price
        let eth: Price
        let usd: Price
        let aud: Price
    }
    struct Price: Codable
    {
        let name: String
        let unit: String
        let value: Float
        let type: String
    }
    

    
    
    
    func formatPrice(_ price: Price) -> String
    {
        return String(format: "%@ %.4f", price.unit, price.value)
    }
    
    func formatDate(date: Date)-> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM y HH:mm:ss"
        return formatter.string(from: date)
    }
    
    
    func setPrices(currency: Currency)
    {
        DispatchQueue.main.async {
            self.btcLabel.text = self.formatPrice(currency.btc)
            self.ethLabel.text = self.formatPrice(currency.eth)
            self.usdLabel.text = self.formatPrice(currency.usd)
            self.audLabel.text = self.formatPrice(currency.aud)
            self.lastUpdateLabel.text = self.formatDate(date: Date())
        }
    }


}

