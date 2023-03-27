//
//  ContentView.swift
//  SampleFireBaseApp
//
//  Created by 渡邊魁優 on 2023/03/26.
//

import SwiftUI
import FirebaseDatabase

struct ContentView: View {
    @State var message = ""
    @State var savedMessage = ""
    
    var body: some View {
        VStack {
            VStack {
                TextField("", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                Button(action: {
                    let ref = Database.database().reference()
                    ref.child("message")
                        .setValue(message)
                }) {
                    Text("保存")
                }
            }
            .padding()
            
            VStack {
                Text("保存されている値 : " + savedMessage)
                
                Button(action: {
                    let ref = Database.database().reference()
                    ref.child("message")
                        .getData { (error, snapshot) in
                            if let error = error {
                                print("Error getting \(error)")
                            }
                            if let result = snapshot {
                                guard let message = result.value as? String else {
                                    return
                                }
                                self.savedMessage = message
                            }
                            else {
                                print("error")
                            }
                        }
                }) {
                    Text("更新")
                }
            }
        }
        .onAppear {
            let ref = Database.database().reference()
            ref.child("message")
                .getData { (error, snapshot) in
                    if let error = error {
                        print("Error getting data \(error)")
                    }
                    if let result = snapshot {
                        guard let message = result.value as? String else {
                            return
                        }
                        self.message = message
                    }
                    else {
                        print("No data available")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
