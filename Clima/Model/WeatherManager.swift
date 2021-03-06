//
//  WeatherManager.swift
//  Clima
//
//  Created by kenjimaeda on 01/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation




protocol WeatherManagerDelegate {
    func didUpdateWether(_ weatherManager: WeatherManager   ,_ wheater: WeatherModel)
    
    func didFailWithError(_ error:Error)
}


struct WeatherManager {
    
    
    var delegateWeather: WeatherManagerDelegate?
    
    func getUrl(cityName:String){
        //importante ser https, se der erro de politica ou seguranca pode
        //ser porque esta em http
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=0f71147fe73f64e20493b89e3e439636&units=metric"
        fetchData(url)
    }
    
    //sobrecarga de funcao e possivel porque sao paremetros diferentes
    func getUrl(_ lon: CLLocationDegrees,_ lat: CLLocationDegrees){
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=0f71147fe73f64e20493b89e3e439636"
        fetchData(url)
    }
    
    func fetchData(_ urlString:String) {
        //1 create url
        //abaixo e uma maneira segura de verificar se existe url
        //caso exista sera passado para a variavel que criamos
        //safeUrl e para evitar erros de escrita no momento de chamar url
        //url nao aceita espacos ,caracter especiais
        let safeUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //a variavel url vai assumir retorno dessa condicao do if, e uma maniera
        //segura para subistuir  null colepsing
        if let url = URL(string: safeUrl ?? urlString) {
            //2 create session url session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){(data,response,error) in
                //vou printar o erro e para funcoa se encontrar erro
                if error != nil {
                    delegateWeather?.didFailWithError(error!)
                    return
                }
                // decodifcar
                if let safeData = data {
                    //quando tem uma funcao dentro de outra precisa chamar dessa maneira
                    if let weatherData =   jsonParse(weatherData: safeData){
                        //self e este objeto que esta sendo chamado
                        delegateWeather?.didUpdateWether(self,weatherData)
                    }
                }
            }
            
            //inicia a task
            task.resume()
        }
        
    }
    
    func jsonParse(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(WeatherData.self, from: weatherData)
            let name = response.name
            let temp = response.main.temp
            let id = response.weather[0].id
            return WeatherModel(id:id,temp: temp,name: name)
        }catch {
            delegateWeather?.didFailWithError(error)
            return nil
        }
    }
    
    
}
