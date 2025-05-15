//
//  ContentView.swift
//  QuickCal
//
//  Created by Varun Valiveti on 4/25/25.
//

import SwiftUI
import AppKit

struct ChatView: View {
    
    @StateObject private var viewModel = ChatViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var icsURL: URL?
    @State private var showingShare = false
    @State private var isHoveringGenerate = false
    @State private var isHoveringLogout = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("QuickCal")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text("Your personal calendar assistant")
                            .font(.title3)
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        appViewModel.logout()
                    }) {
                        Text("Log Out")
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 1.5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(isHoveringLogout ? Color.red.opacity(0.1) : Color.white)
                                    )
                            )
                            .scaleEffect(isHoveringLogout ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: isHoveringLogout)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        isHoveringLogout = hovering
                    }
                }
                .padding(.bottom, 24)
                                
                Text("Tell us your event!")
                    .font(.headline)
                    .foregroundColor(.black)
                
                ZStack(alignment: .leading) {
                    if $viewModel.prompt.wrappedValue.isEmpty {
                        Text("Input Event")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                    }
                    TextField("", text: $viewModel.prompt)
                        .padding(.horizontal)
                        .foregroundColor(.black)
                        .frame(height: 44)
                        .frame(maxWidth: 320)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .onSubmit {
                            viewModel.handlePromptSubmit()
                        }
                }
                .background(Color.white)
                
                if viewModel.response.isEmpty {
                    Button(action: {
                        viewModel.handlePromptSubmit()
                    }) {
                        Text("Generate Event")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 180, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isHoveringGenerate ? Color.red.opacity(0.8) : Color.red)
                            )
                            .scaleEffect(isHoveringGenerate ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: isHoveringGenerate)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        isHoveringGenerate = hovering
                    }
                    .padding(.top, 8)
                    
                } else {
                    Button(action: {
                        viewModel.handleReset()
                    }) {
                        Text("Reset")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 180, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isHoveringGenerate ? Color.red.opacity(0.8) : Color.red)
                            )
                            .scaleEffect(isHoveringGenerate ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: isHoveringGenerate)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        isHoveringGenerate = hovering
                    }
                    .padding(.top, 8)
                }
                
                Text("Event")
                    .font(.headline)
                    .foregroundColor(.black)
                
                // Placeholder for event response
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 60)
                    .frame(maxWidth: 300)
                    .overlay(
                        HStack(spacing: 12) {
                            Image(systemName: "calendar.badge.clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 45)
                                .foregroundColor(.red)
                            Text(!viewModel.eventTitle.isEmpty ? viewModel.eventTitle : "Your event will appear here")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                        .padding(.horizontal)
                    )
                    .padding(.horizontal)
                
                if !viewModel.response.isEmpty {
                    Button(action: {
                        do {
                            // print(viewModel.response)
                            let url = try viewModel.saveICS(viewModel.response)
                            NSWorkspace.shared.open(url)
                        } catch {
                            print("Couldn't open .ics file", error)
                        }
                    }) {
                        Text("Add Event")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(width: 180, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 8)
                    .opacity(0.5)
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
}
