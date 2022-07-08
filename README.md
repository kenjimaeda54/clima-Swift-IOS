# App Clima
Aplicativo de clima,consumindo [Weather API](https://openweathermap.org/)


## Motivacao
Aprender o desing patern Delegate, melhorar no desing partern MVC , praticar conceitos anteriores e como usar localização real do usuário

## Feature
- Desing Patern Delegate e algo frequente utilizado pela Appple
- Base desse desing e disponibilizar através de [protocolos](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html) métodos prontos para uso 
- Abaixo exemplo do protocolo [UITextFieldDelegate](https://developer.apple.com/documentation/uikit/uitextfielddelegate)
- Através desse protocolo tenho acesso quando usuário pretende digitar algo no input, finalizou ou está digitando
- E bastante útil para iniciar o keyboard do aparelho, fechar ou atualizar algum dado
- Não pode esquecer ao usar um protocolo instanciar o delegate usando o self
- Outra funcionalidade interessante que aprendi e o uso do [extension](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html) com ele consigo estender minhas próprias feature usando um tipo primitivo, classe,struct
- weatherManger e um delegate que eu criei, preciso instanciar o self na classe que pretendo utilizar meu protocolo
- A clase que vai criar a lógica de negócio apenas instancio como se fosse objeto



```swift



protocol WeatherManagerDelegate {
    func didUpdateWether(_ weatherManager: WeatherManager   ,_ wheater: WeatherModel)
    
    func didFailWithError(_ error:Error)
}



struct WeatherManager {

var delegateWeather: WeatherManagerDelegate?


}

class WeatherViewController: UIViewController {

    
override func viewDidLoad() {

  locationManager.delegate = self
  weatherManager.delegateWeather = self
  searchTextInput.delegate = self
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

```
##
- Aprendi o uso do [CoreLocation](https://developer.apple.com/documentation/corelocation/cllocationmanager),precisa em info do .list descrever em Privacy- Location When In Use Description um valor
- Este valor sera usado para o aplicativo quando requisitar o uso da localizacao
- Para funcionar corretamente precisa o delegate ser chamado antes do requestLocation e implementar o protocolo de falha
- Caso deseja atualizacao constante do usuario seria interssante uso do metodo [startUpdatingLocation](https://developer.apple.com/documentation/corelocation/cllocationmanager/1423750-startupdatinglocation)
- Examples de casos de uso,aplicativo de entrega

```swift

class WeatherViewController: UIViewController {


   override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

  }
}
```

##
- Requisições de Api precisa de algumas etapas
- Primeiro criar uma url com objeto URL(), para isto preciso usar addPercentEncoding para garantir ser  uma url valida   
- Depois crio a URLSession, apos isto inicio as task e por fim uso o JSONDecoder
- Precisa lembrar que esse método e assíncrono se deseja atualizar a Ui com os valores da api utilizo o método DispatchQueue.main.asyn
- Toda vez que vou manipular algo da api e interessante criar suas tipagens, para isto usei   struct
- Os dados precisam ser idênticos da api, por exemplo, id, temp, name


```swift

struct WeatherModel {
 func fetchData(_ urlString:String) {
        let safeUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: safeUrl ?? urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){(data,response,error) in
            
                if error != nil {
                    delegateWeather?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    //quando tem uma funcao dentro de outra precisa chamar dessa maneira
                    if let weatherData =   jsonParse(weatherData: safeData){
                        //self e este objeto que esta sendo chamado
                        delegateWeather?.didUpdateWether(self,weatherData)
                    }
                }
            }
            
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
 
//tipagens 
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

//ui

extension WeatherViewController:WeatherManagerDelegate{
    
    func didUpdateWether(_ weatherManager: WeatherManager,_ wheater: WeatherModel)  {
      
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
```

##
- Utilizei muitas feature nativas do swift que facilita o código
- Exemplo do uso de  [Computed property](https://www.avanderlee.com/swift/computed-property/)
- Uma variável vai assumir o retorno de um expressão, assim evito linhas criando funções
- Aprendi novos usos para o [Optional Chaining](https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html)
- Com esse método quando minha variável não ser nula vai receber o valor logico que esta na expressão 
- Exemplo do uso option chaining quando weahterData não for nullo a variável vai assumir o valor da função jsonParse
- Exemplo do computed property, quando swfit retornar algo, variável contionIcon assumira esse valor
- Aprendi tipar array de objetos em Swift

```swift
if let weatherData =   jsonParse(weatherData: safeData){
   delegateWeather?.didUpdateWether(self,weatherData)
 }

//
    
    var conditionIcon: String {
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
            return  "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
        
    }
```



            










