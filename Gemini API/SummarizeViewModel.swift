//
//  SummarizeViewModel.swift
//  Gemini API
//
//  Created by Gilang Ramadhan on 22/07/24.
//
import Foundation
import GoogleGenerativeAI
import OSLog

@MainActor
class SummarizeViewModel: ObservableObject {
  private var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "generative-ai")
  
  @Published var outputText = ""
  @Published var errorMessage: String?
  @Published var inProgress = false
  
  private var model: GenerativeModel?
  
  init() {
    model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: "YOUR_API_KEY")
  }
  
  func summarize(inputText: String) async {
    defer {
      inProgress = false
    }
    guard let model else {
      return
    }
    
    do {
      inProgress = true
      errorMessage = nil
      outputText = ""
      
      let prompt = "Describes the following text for me: \(inputText)"
      let outputContentStream = model.generateContentStream(prompt)
      
      for try await outputContent in outputContentStream {
        guard let line = outputContent.text else {
          return
        }
        outputText = outputText + line
      }
    } catch {
      logger.error("\(error.localizedDescription)")
      errorMessage = error.localizedDescription
    }
  }
}
