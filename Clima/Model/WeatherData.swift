//
//  WeatherData.swift
//  Clima
//
//  Created by kenjimaeda on 06/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
//precisa criar mesma estrura de dados identico  que esta na url
//e um json de objeto
//tipo Decodable e porque vou usar um metodo do
//JsonDecoder

//precisa ser memsmo formato,nome de variaveis que estao
//na url
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}





