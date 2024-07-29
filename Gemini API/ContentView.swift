//
//  ContentView.swift
//  Gemini API
//
//  Created by Gilang Ramadhan on 22/07/24.
//

import SwiftUI
import MarkdownUI

struct ContentView: View {
  @StateObject var viewModel = SummarizeViewModel()
  @State var userInput = ""
  
  enum FocusedField: Hashable {
    case message
  }
  
  @FocusState
  var focusedField: FocusedField?
  
  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        Text("Enter some text, then tap on _Go_ to describe it.")
          .padding(.horizontal, 6)
        HStack(alignment: .top) {
          TextField("Enter text describes", text: $userInput, axis: .vertical)
            .focused($focusedField, equals: .message)
            .textFieldStyle(.roundedBorder)
            .onSubmit {
              onSummarizeTapped()
            }
          Button("Go") {
            onSummarizeTapped()
          }
          .padding(.top, 4)
        }
      }
      .padding(.horizontal, 16)
      
      List {
        HStack(alignment: .top) {
          if viewModel.inProgress {
            ProgressView()
          } else {
            Image(systemName: "cloud.circle.fill")
              .font(.title2)
          }
          Markdown("\(viewModel.outputText)")
        }.listRowSeparator(.hidden)
      }.listStyle(.plain)
    }.navigationTitle("Text sample")
  }
  
  private func onSummarizeTapped() {
    focusedField = nil
    Task {
      await viewModel.summarize(inputText: userInput)
    }
  }
}

#Preview {
    ContentView()
}
