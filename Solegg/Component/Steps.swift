import SwiftUI
import Foundation

class Steps: ObservableObject {
    @Published var goals: [Goal] = [
        Goal(state:false, name: "Abrir ventana", content: Modal(imageName: "fan.floor", title:"Refresca tu casa", desc:"da paso a qque pueda circular el aire en tu casa :)", exp:2)),
        Goal(state:false, name: "Tomar agua", content: Modal(imageName: "humidity.fill", title:"hidratate", desc:"glulgulugluglug", exp:10)),
        Goal(state:false, name: "Cositas", content: Modal(imageName: "square.and.arrow.up.fill", title:"idk", desc:"lol", exp:10)),
        Goal(state:false, name: "second second", content: Modal(imageName: "exclamationmark.triangle.fill", title:"yeee", desc:"ñp", exp:10)),
        Goal(state:false, name: "Abrir ventana", content: Modal(imageName: "fan.floor", title:"Refresca tu casa", desc:"da paso a qque pueda circular el aire en tu casa :)", exp:2)),
        Goal(state:false, name: "Tomar agua", content: Modal(imageName: "humidity.fill", title:"hidratate", desc:"glulgulugluglug", exp:10)),
        Goal(state:false, name: "Cositas", content: Modal(imageName: "square.and.arrow.up.fill", title:"idk", desc:"lol", exp:10)),
        Goal(state:false, name: "second second", content: Modal(imageName: "exclamationmark.triangle.fill", title:"yeee", desc:"ñp", exp:10)),
    ]
    
    @Published var currentIndex: Int = 0
    @Published var activeModal = false
    
    
    var currentGoal: Goal{
        goals [currentIndex]
    }
    
    func showModal(){
        activeModal=true
    }
}

