//
//  ContentView.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        VStack {
            Home()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View{
    @State
    var models = [
        Model(id: 0, name: "Earth" ,modelName: "Earth.usdz", details: "bscyudbvjkwnlkd")
    ]
    
    @State var index = 0
    
    var body: some View{
        VStack{
            SceneView(scene: SCNScene(named: "new_model.obj"/* models[index].modelName */), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height / 2)

            /*
            ZStack{
                
                HStack{
                    Button(action: {
                        withAnimation{
                            
                            if index > 0{
                                
                                index -= 1
                            }
                        }
                    }, label: {
                        
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 35, weight: .bold))
                            .opacity(index == 0 ? 0.3 : 1)
                    })
                    .disabled(index == 0 ? true : false)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        withAnimation{
                            
                            if index < models.count{
                                
                                index += 1
                            }
                        }
                    }, label: {
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 35, weight: .bold))
                            .opacity(index == models.count - 1 ? 0.3 : 1)
                    })
                    .disabled(index == models.count - 1 ? true : false)
                }
                /*
                Text(models[index].name)
                    .font(.system(size: 45, weight: .bold))
                 */
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            .padding(.vertical,30)
            
            VStack(alignment: .leading, spacing: 15,
                content: {
                
                Text("About")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(models[index].details)
                
                }
            )
            .padding(.horizontal)
            
            Spacer(minLength: 0)
             */
        }
    }
}

struct Model : Identifiable {
    
    var id : Int
    var name : String
    var modelName : String
    var details : String
}

