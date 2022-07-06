//
//  WeatherModel.swift
//  Clima
//
//  Created by kenjimaeda on 06/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel {
    let id: Int
    let temp: Double
    let name: String
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    //computed property
    //https://www.avanderlee.com/swift/computed-property/
    //computed property e a posibilidade de uma variavel
    //assumir o retorno de um expressao
    //voce precisa usar var,porque altera de valor de acordo
    //com retorno
    var conditionIcon: String {
        // poderia fazer dessa maneira,porem minha pesquisa seria limitado
        //     let conditionWeather = [800:"cloud",804:"cloud.sun"]
        
        //        let iconWeather = conditionWeather[id]
        //        print(iconWeather ?? "not found icon")
        
        //assim abranjo mais possibilidades
        // ... e um range
        
        //id que esta aqui e o declarado la em cima no let
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return  "sum.max"
        case 801...804:
            return "cloud.bold"
        default:
            return "cloud"
        }
        
    }
}
