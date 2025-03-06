import SwiftUI
import FirebaseVertexAI

struct ContentView: View {
    @State private var userInput = ""
    @State private var vertex: VertexAI?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Input event below")
            TextField("Type here ...", text: $userInput)
            
            Button("Go!") {
                print(userInput)
                Task {
                    await createEvent()
                }
            }
        }
        .padding()
        .onAppear {
            // Initialize VertexAI after the view appears
            self.vertex = VertexAI.vertexAI()
            print("VertexAI initialized in onAppear")
        }
    }
    
    func createEvent() async {
        guard let vertex = vertex else {
            print("VertexAI not initialized")
            return
        }
        
        let model = vertex.generativeModel(modelName: "gemini-2.0-flash")
        do {
            let response = try await model.generateContent(userInput)
            print(response.text ?? "No text in response")
        } catch {
            print("Something went wrong: \(error.localizedDescription)")
        }
    }
}
