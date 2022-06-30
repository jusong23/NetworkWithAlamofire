//
//  ViewController.swift
//  newtorkEx
//
//  Created by 이주송 on 2022/06/30.
//

import UIKit

import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTest()
//        self.fetchCovidOverview(completionHandler: {
//            [weak self] result in
//            guard let self = self else {return}
//            switch result {
//            case let .success(result):
//                debugPrint("success \(result)")
//            case let .failure(error):
//                debugPrint("error")
//            }
//        })
    
    }

//MARK: - GET으로 서버에서 값을 가져오기(serviceKey가 필요없는 URL) 서버에서 만든 어떤 URL이든 접근해서 GET으로 값 가져오는 Method
    
    func getTest() {
        let url = "https://jsonplaceholder.typicode.com/todos/1"
        AF.request(url,
                   method: .get, // 어떤 통신방식을 사용할 지
                   parameters: nil, // 서버로 보낼 parameter를 담는 것(POST)
                   encoding: URLEncoding.default, // URL을 통해 접근할 것이니 URLEncoding
                   headers: ["Content-Type":"application/json", "Accept":"application/json"]) // json 형식으로 받게끔
        .validate(statusCode: 200..<300) // 에러여부
        .responseJSON{
            (json) in debugPrint(json)
        } // 정보를 받는 부분
    }

    
//MARK: - POST로 서버에 값을 내보내기 :: 서버에서 이 데이터를 Json 파일에 저장할 수 있음?

    func postTest() {
            let url = "https://ptsv2.com/t/prvrx-1656587086/post"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
            
            // POST 로 보낼 정보
            let params = [
                "Test key_1": url,
                "Test key_2": "ss"
            ]

            // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("http Body Error")
            }
            
            AF.request(request).responseString { (response) in
                switch response.result {
                case .success:
                    print("POST 성공")
                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                }
            }
        }
    
//MARK: - serviceKey가 필요한 URL , 따로 만든 구조체에 넣는 Tric 기록
    
    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
    // 함수 밖에서도 돌아가도록 (비동기작업)
    ) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "Px1O9jwLSGqiCtYUfdvspkBJcNaroDHIW"
        ]
        
        AF.request(url, method: .get, parameters: param) // get 방식 : url에 data담아 보내는 형식
        // 위에 param을 정의한거 처럼 딕셔너리 형태로 저장을하면 알아서 요청한 url뒤에 query parameter가 붙여짐!
            .responseData(completionHandler: { response in // 응답데이터를 받을수 있는 메소드를 Chaning
                switch response.result { // 요청에 대한 응답 결과
                case let .success(data): // 요청 O
                    do { // 요청 O 응답 O
                        let decoder = JSONDecoder()
                        // json 객체에서 data 유형의 인스턴스로 디코딩하는 객체! Decodable, Codable 프로토콜을 준수하는 라인!
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        // 서버에서 전달받은 data를 매핑시켜줄 객체타입으로 CityCovideOverview를 설정
                        completionHandler(.success(result))
                        // 응답이 완료되면. Completion Handler가 호출됨 -> result를 넘겨받아 data가 구조체로 매핑
                    } catch { // 요청 O 응답 X
                        completionHandler(.failure(error))
                        // 응답을 못받으면 error를 받음
                    }
                    
                case let .failure(error): // 요청 X
                    completionHandler(.failure(error))
                }
            })
    }
}

