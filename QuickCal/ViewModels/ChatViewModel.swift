//
//  ChatViewModel.swift
//  QuickCal
//
//  Created by Varun Valiveti on 4/25/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class ChatViewModel: ObservableObject {
    
    @Published var prompt: String = ""
    @Published var response: String = ""
    @Published var eventTitle: String = ""
    let db = Firestore.firestore()
    
    // FUNCTION: handles the submission of a chat prompt, interacting with the backend
    func handlePromptSubmit() {
        // print("prompt is: \(prompt)")
        // backend url validation
        guard let url = URL(string: "http://localhost:5001/receive-event") else {
            print("Invalid URL")
            return
        }
        
        // create the request body
        // print("userid is ",Auth.auth().currentUser!.uid)
        let promptRequest = PromptRequest(userId: Auth.auth().currentUser!.uid,
                                            request: prompt)
        
        // parse it into json format
        guard let jsonData = try? JSONEncoder().encode(promptRequest) else { return }
        
        // formulate the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // send the network request
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // null return value handling
            guard let data = data else {
                print("No data in response")
                return
            }
            
            // error handling
            if let error = error {
                print("Request error: \(error)")
                return
            }
            
            // extract the json data
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                if let response = json?["response"] as? String {
                    DispatchQueue.main.async {
                        self.response = response
                        // print("RESPONSE: ", self.response)
                    }
                    
                    if let summaryLine = response
                        .components(separatedBy: "\n")
                        .first(where: { $0.starts(with: "SUMMARY:") }) {
                        
                        let eventTitle = summaryLine.replacingOccurrences(of: "SUMMARY:", with: "")
                        DispatchQueue.main.async {
                            self.eventTitle = eventTitle
                            print("EVENT TITLE: ", self.eventTitle)
                        }
                    } else {
                        print("No SUMMARY line found in calendar string.")
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.response = "Error retrieving prompt response"
                    self.eventTitle = "Error"
                }
            }
        }.resume()
    }
    
    func saveICS(_ icsText: String) throws -> URL {
        // print("icsText is ",icsText)
        func makeRandomICSFilename() -> String {
            // A UUID is guaranteed unique and random
            let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            // print(uuid)
            return "\(uuid).ics"
        }
        let filename = makeRandomICSFilename()
        
        
        let url = FileManager.default.temporaryDirectory
                    .appendingPathComponent(filename)
        try icsText.write(to: url, atomically: true, encoding: .utf8)
        print(url)
        return url
    }
    
    func handleReset() {
        self.prompt = ""
        self.response = ""
        self.eventTitle = ""
    }

}

