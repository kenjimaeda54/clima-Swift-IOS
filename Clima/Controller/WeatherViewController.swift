//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

//UITextFieldDelegate e um protocolo para administrar o valor digitado no campo do input
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextInput: UITextField!
    
    var weatherManager = WeatherManager()
    //precisa importar CoreLocation
    var locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //isto e importante para searchTextInput ser a referencia do delegate
        
        //nao pode esquecer de chamar a variavel
        //que esta instanciado o protocolo dentro de WeatherManager
        //na struct WeatherManager tem uma variavel chamada
        //delegateWeather que faz inferencia ao protocolo
        
        //NAO ESQUECA TODO PROTOCOLO PRECISO DO SELF
        //neste caso o delegate responsavel pelo location precisa estar
        //antes do requestWhenInUseAuthorization e requestLocation
        locationManager.delegate = self
        weatherManager.delegateWeather = self
        searchTextInput.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        //tem outros metodos este pega apenas uma vez a localizacao
        //https://developer.apple.com/documentation/corelocation/cllocationmanager
        locationManager.requestLocation()
        
    }
    
    
    
    @IBAction func buttonSearch(_ sender: UIButton) {
        //forco fechar o teclado
        searchTextInput.endEditing(true)
        print(searchTextInput.text!)
    }
    
    @IBAction func pressLocationCurrent(_ sender: UIButton) {
        //para isto funcionar preciso cancelar a localicazao no metodo que e chamado
        //apos requestLocation no caso locationManager
        locationManager.requestLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            //ASSIM SEMPRE RECINICIO A REQUISICAO DE LOCALIZACAO
            locationManager.stopUpdatingLocation()
            weatherManager.getUrl(longitude,latitude)
        }
        
    }
    
    //necessario printar o error caso aconteca
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - UITextFieldDelegate
// mark e para separar as secoes no cabecalho, apenas estetico

extension WeatherViewController: UITextFieldDelegate  {
    
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

// MARK: - WeatherManagerDelegate

extension WeatherViewController:WeatherManagerDelegate{
    
    func didUpdateWether(_ weatherManager: WeatherManager,_ wheater: WeatherModel)  {
        //essencial chamar esse metodo quando estamos lidando
        //com atualizacao de dados de acordo com uma requisicao de servidor
        DispatchQueue.main.async {
            self.temperatureLabel.text = wheater.tempString
            self.conditionImageView.image = UIImage(systemName: wheater.conditionIcon)
            self.cityLabel.text = wheater.name
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
