//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

//UITextFieldDelegate e um protocolo para administrar o valor digitado no campo do input
class WeatherViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextInput: UITextField!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //isto e importante para searchTextInput ser a referencia do delegate
        searchTextInput.delegate = self
    }
    
    @IBAction func buttonSearch(_ sender: UIButton) {
        //forco fechar o teclado
        searchTextInput.endEditing(true)
        print(searchTextInput.text!)
    }
    
    //metodo disponivel no UITextFieldDelegate, ele e chamado quando usuario clica no teclado para
    //finalizar a edicao,a propriedade e return key no story board
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //forco fechar o teclado
        searchTextInput.endEditing(true)
        print(searchTextInput.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            searchTextInput.placeholder = "Type something  here"
            return false
        }else {
            searchTextInput.placeholder = "Search"
            return true
        }
    }
    
    //metodo disponivel no UITextFieldDelegate
    //esse metodo e chamado quando finaliza a edicao
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            weatherManager.getUrl(cityName: textField.text!)
        } 
        searchTextInput.text = ""
    }
    
}

